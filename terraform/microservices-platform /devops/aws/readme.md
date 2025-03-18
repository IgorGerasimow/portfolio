## What is this project about
This project is here to make it easier to run common services in kubernetes by taking care of it for you so that you can get to working on your application faster instead of dealing with infrastructure components.

When running your application in Kubernetes, you often add various open source applications to your cluster to help you automatically get Let's Encrypt certificates for your HTTPS endpoints and automatically renewing them, automatically sync DNS entries that you have on an ingress to your DNS provider, monitoring and alerting for your cluster, and many more items.

These services are super fantastic and works really well but it takes time to set them up, integrate it into your cluster and then over the lifetime of it, you have to revisit each one to update them.  This is all undifferentiated heavy lifting that you have to take care of in addition to your own application.

This project integrates and maintains (with updates) all of these open source applications for you so you don't have to do it.

![ManagedKube Kubernetes Common Services](./docs/images/common-services.png "ManagedKube Kubernetes Common Services")


## Who is this project for
This project is for people who do not want to manage these common applications and let the open source community manage it.  Just like how you don't manage the various pieces to Kubernetes and integrate it together, you instead use a product like GKE, EKS, AKS, Rancher, Kops, Kubespray, etc.  You don't also have to manage these common Kubernetes services either.  If you want to offload that work, this project is for you.

## Why do I want to use this project
Setting up and maintaining these application and integrating it with your cloud is a lot of work you have to do before you even start on your application.  This project helps accelerate your process and gets you to running your application on Kubernetes faster by taking care of the undifferentiated heavy lifting of the infrastructure work for you and keeping it maintained going forward.

## What this project provides
There is no magic here.  Everything in here you can do and everything we use is absolutely 100% open source.  The value add this project provides is an opinionated way of deploying these items and the curration of each service.  We put in the work to make sure everything is structured correctly, updated in a timely manor, and reasonably easy to use.  The other major piece is that we validate that these pieces are working in various types of Kubernetes clusters and clouds.

## Supported Services

* [cert-manager](https://github.com/jetstack/cert-manager) (For HTTPS certs)
* [cluster-turndown](https://github.com/kubecost/cluster-turndown) (Automated turndown of Kubernetes clusters on specific schedules.)
* [kube-metric-adapter](https://github.com/zalando-incubator/kube-metrics-adapter) (Scale by any Prometheus metrics)
* [nginx-ingress](https://github.com/helm/charts/tree/master/stable/nginx-ingress) (To expose HTTP services to consumers from outside of the cluster such as the internet)
* [prometheus-blockbox-exporter](https://github.com/prometheus/blackbox_exporter) (checks on URLs)
* [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) (Monitoring and alerting for your cluster)
* [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) (Keep your secrets encrypted in Git and delivered as secrets into Kubernetes)

If you don't see a service that you want to use but want us to support it, please open an issue in this project and let us know!


# The stack this will create

![the stack](./docs/images/kubernetes-managed-service-stack-v2.png)


## Supported built in services
These are the list of services that are maintained for each cloud

| Service Name                    | Supported in AWS  | Supported in GCP  | source             |
|---                              |---                |---                |---      |
| cluster-autoscaler              | yes               | no                | helm/stable        |
| kube-downscaler                 | yes               | yes               | helm/stable        |
| loki                            | yes               | yes               | loki               |
| prometheus operator             | yes               | yes               | helm/stable        |


