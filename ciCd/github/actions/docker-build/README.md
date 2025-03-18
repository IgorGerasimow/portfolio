<!-- action-docs-description -->
## Description

This action wraps `docker/build-push-action`, to ensure that
all docker images build by Fatmouse pipelines follow same patterns.

It's expected that `Buildx` is already installed with `docker/setup-buildx-action`.
<!-- action-docs-description -->

<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| context | Build's context | `true` |  |
| file | Path to the Dockerfile. | `true` |  |
| image | Image name | `true` |  |
| build-contexts | List of additional build contexts (e.g., name=path) | `false` |  |
| build-args | List of build-time variables | `false` |  |
| tags | Semver tagging strategy. Default none. (see https://github.com/docker/metadata-action#typesemver) | `false` |  |
<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
