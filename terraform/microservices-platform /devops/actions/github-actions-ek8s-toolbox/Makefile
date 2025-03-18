VERSION?=v1

build:
	docker build --no-cache -t docker.pkg.github.com/Example/tg-modern/action-k8s-toolbox/app:$(VERSION) . -f Dockerfile

push:
	docker push docker.pkg.github.com/Example/tg-modern/action-k8s-toolbox/app:$(VERSION)

bp: build push