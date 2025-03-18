`Task`

```
Write an application with the purpose of pruning any images that are older than 30 minutes AND
not within the latest three versions (tags).
Please use the Docker API (eg. https://docker-py.readthedocs.io/en/stable/ ), not shell out to
docker on command line.

```

Results, for test i used same `golang` image with mulpitple tags 0-4 and run script twice 


```
Setup
root@greenbone:/home/ihor_gerasimov# docker images 
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
golang                          4               73cd0b4a32ae   3 days ago     915MB
golang                          3               f664b49d14d2   3 days ago     915MB
golang                          2               0bf7104686fc   3 days ago     915MB
golang                          0               8f9a0149426f   3 days ago     915MB
golang                          1               8f9a0149426f   3 days ago     915MB

Result after execution
root@greenbone:/home/ihor_gerasimov# docker images 
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
golang                          4               73cd0b4a32ae   3 days ago     915MB
golang                          3               f664b49d14d2   3 days ago     915MB
golang                          2               0bf7104686fc   3 days ago     915MB
```

After that i build additional 3 more tags for image `golang`

```
Setup
root@greenbone:/home/ihor_gerasimov/Dockerizing-a-NodeJS-web-app# docker images 
REPOSITORY                      TAG             IMAGE ID       CREATED              SIZE
golang                          7               0ce454cf62ff   8 seconds ago        915MB
golang                          6               f4d108d2bf1b   23 seconds ago       915MB
golang                          5               f5c3bd9fcd7a   About a minute ago   915MB
golang                          4               73cd0b4a32ae   3 days ago           915MB
golang                          3               f664b49d14d2   3 days ago           915MB
golang                          2               0bf7104686fc   3 days ago           915MB

Result 
root@greenbone:/home/ihor_gerasimov# docker images 
REPOSITORY                      TAG             IMAGE ID       CREATED              SIZE
golang                          7               0ce454cf62ff   About a minute ago   915MB
golang                          6               f4d108d2bf1b   2 minutes ago        915MB
golang                          5               f5c3bd9fcd7a   2 minutes ago        915MB
```

script save logs and deleted images to file 

```
INFO:root:Before pruning, total images: 21
INFO:root:Pruning image: golang:0
INFO:root:Pruning image: golang:0
ERROR:root:Failed to remove image golang:0: Docker API error - 404 Client Error for http+docker://localhost/v1.42/images/sha256:8f9a0149426f7fe1d5e9dd6cdbce91dae645909c21b0ad1f080a3c6de697452e?force=True&noprune=False: Not Found ("No such image: sha256:8f9a0149426f7fe1d5e9dd6cdbce91dae645909c21b0ad1f080a3c6de697452e")
INFO:root:After pruning, total images: 20
INFO:root:Before pruning, total images: 23
INFO:root:Pruning image: golang:4
INFO:root:Pruning image: golang:3
INFO:root:Pruning image: golang:2
INFO:root:After pruning, total images: 20
```