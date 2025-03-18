# traefik-basic-auth

This folder contains kubenernetes resources necessary to be applied to a cluster intending to activate trafik basic auth middleware on ingressRoute resources.

## Dependencies:
- Depends on a preconfigured set of Traefik CRDs, see: [this link](https://docs.traefik.io/providers/kubernetes-crd/)
- You must have configured kubectl access for your cluster, this requires your aws cli to be authetnicated and your kube config to be updated: using [update-kubeconfig](https://docs.aws.amazon.com/cli/latest/reference/eks/update-kubeconfig.html)
- Access to AWS Secret Manager to fetch the secret value.



## Deploying the resources
This repo contains two resources:
- traefik-basic-auth.yaml
- traefik-basic-secret.yaml

***WARNING! YOU WILL NOT BE ABLE TO DEPLOY traefik-basic-secret.yaml WITHOUT THE BASE64 ENCODED VALUE IN AWS SECRET MANAGER. DO NOT COMMIT THE VALUE TO GIT.***

```bash

$ kubectl config use-context <your-prod-context>
$ kubectl apply -f traefik-basic-secret.yaml -f traefik-basic-auth-middlware.yaml
```

## Contact

If you have questions about how to use this or how to get access to Secret Manager reach out to:

andrew.polidori@theguarantors.com