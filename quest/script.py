import docker
from docker.errors import APIError
import logging
from datetime import datetime, timedelta
from collections import defaultdict
import pytz  # for timezone handling

# Setting up logging
logging.basicConfig(filename='docker_image_prune.log', level=logging.INFO)

try:
    client = docker.from_env()
except Exception as e:
    logging.error("Failed to connect to Docker: %s", e)
    raise

def prune_images():

    # Get a list of all images
    all_images = client.images.list(all=True)

    logging.info('Before pruning, total images: %d', len(all_images))

    # Group by image name
    image_groups = defaultdict(list)
    for image in all_images:
        for tag in image.tags:
            name, version = tag.split(":", 1)
            image_groups[name].append((version, image))

    for image_name, images in image_groups.items():
        images.sort(reverse=True)  # sort versions in descending order
        for i, (version, image) in enumerate(images):
            # preserve the latest 3 versions, ignore images without repository tags
            if i > 2 or not image.tags:
                try:
                    # get image creation time
                    created_time_str = image.attrs['Created']
                    created_time_str = created_time_str.replace("Z", "+00:00")
                    # trim the string to microseconds before converting to datetime
                    created_time = datetime.fromisoformat(created_time_str[:26]+created_time_str[29:])

                    # check if image is older than 30 minutes
                    if created_time < datetime.now(pytz.utc) - timedelta(minutes=30):
                        logging.info('Pruning image: %s', image.tags[0])
                        client.images.remove(image.id, force=True)
                except APIError as e:
                    logging.error('Failed to remove image %s: Docker API error - %s', image.tags[0], e)
                except Exception as e:
                    logging.error('Failed to remove image %s: Unexpected error - %s', image.tags[0], e)

    # Get a list of all images after pruning
    all_images = client.images.list(all=True)

    logging.info('After pruning, total images: %d', len(all_images))

if __name__ == "__main__":
    prune_images()