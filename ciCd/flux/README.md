# aws-flux-company

This repository containes all manifests for kubernetes cluster in Stage and Prod environments.


## Getting started

## Upgrade a tag in HelmRelease

To update a tag in a HelmRelease or in other words to update your application version there are several ways to do it:
1. **Manual way:** \
   Open folder *"apps" -> '$environment' -> '$namespace' ->* open the yaml with HelmRelease of the application you want to deploy and change *spec.values.tag* to a docker tag you want to be deployed.
2. **Automatic FluxV2 updates:** \
   An example: https://git.company.com/flux/stage-duss-shared/-/blob/master/fluxV2/apps/in-app/notification-center/event-originator.yaml#L97
3. **Application repository can curl/trigger CI of aws-flux-company repository.** 
   Use this extend job in your CI: \
   https://git.company.com/DevOps/corp/gitlabci-templates/-/blob/master/.deploy-templates.yml \
   Variables you need to send: *APP, IMAGE_VERSION, PRODUCT, ENV* \
   **An example block of code:**
   ```bash
    variables:
      APP: "company-mail" # The value should be taken from values.labels.app, this value is searched by deploy.sh script
      IMAGE_VERSION: $BUILD_VERSION # A docker tag name
      PRODUCT: "company-mail" # A folder (namespace) name where the target HelmRelease is located
      ENV: stage # A folder name. Should be "stage" or "prod"
      CONTAINER_NAME: queue-processor # This field is optional. Define it when you have more than 1 container in a HelmRelease and need to update tag for a container.
    ```

## Encrypt Kubernetes secrets

In order to store secrets safely in a Git repository,
you can use Mozilla's SOPS CLI to encrypt Kubernetes secrets with OpenPGP or KMS.

Install [gnupg](https://www.gnupg.org/) and [sops](https://github.com/mozilla/sops):

```sh
brew install gnupg sops
```

Generate a Kubernetes secret manifest and encrypt the secret's data field with sops:

```sh
kubectl -n flux-system create secret generic slack-alert-url \
--from-literal=slack-api-url=https://hooks.slack.com/services///
--dry-run=client \
-o yaml > infrastructure/stage/secrets/slack-alert-url.yaml

sops --kms arn:aws:kms:eu-central-1:ID:alias/vault-kms-stage -e --encrypted-regex "^(data|stringData)" infrastructure/stage/secrets/slack-alert-url.yaml
```
Сhoosing a KMS Key according to the AWS account:

| Environment (AWS account) | KMS Key |
| --- | --- |
| AWS-STAGE- | alias/.... |
| AWS-PROD- | alias/..... |

Add the secret to `infrastructure/stage/secrets/slack-alert-url.yaml`:

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - slack-alert-url.yaml
```

Enable decryption on your clusters by editing the `infrastructure.yaml` files:

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: infra-secrets
  namespace: flux-system
spec:
  interval: 5m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure/stage/flux-system/secrets
  prune: true
  decryption:
    provider: sops
```

Push the changes to the main branch:

```sh
git add -A && git commit -m "add encrypted secret" && git push
```

Verify that the secret has been created in the `flux-system` namespace on cluster:

```sh
kubectl -n flux-system get secrets
```

You can use Kubernetes secrets to provide values for your Helm releases:

Find out more about Helm releases values overrides in the
[docs](https://toolkit.fluxcd.io/components/helm/helmreleases/#values-overrides).
