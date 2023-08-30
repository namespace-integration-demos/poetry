# Poetry in Docker

This repository contains a minimal example of a Python app managed by Poetry and fully dockerized.

The Dockerfile has been optimized to minimize build time by maximizing cache usage.

We're using a couple of tricks here:

1. Code changes do not invalidate the dependency build cache. This is achieved by only copying selected files when building dependencies (and deferring the copy of the full app to a later stage).
2. Dependecies remain in the cache even when adding new dependencies. We're storing dependencies in a persistent cache mount to achieve this.
3. Minimize the size of the final docker image by only retaining the virtual environment from the build step.

Give this example a spin with:

```sh
$ nsc build . --name poetry-demo --push
Pushed:
  nscr.io/{your-workspace-id}/poetry-demo:latest


$ nsc run --image nscr.io/{your-workspace-id}/poetry-demo:latest -p 8000

  Created new ephemeral environment! ID: uqsd11c10lb72

  More at: https://cloud.namespace.so/{your-workspace-id}/cluster/uqsd11c10lb72

  Started "poetry-test-b4sv4"

    Exported 8000/tcp as https://4c2k8mg-uqsd11c10lb72.fra1.namespaced.app
```

If you're new to Namespace, get started at [cloud.namespace.so/docs](https://cloud.namespace.so/docs/getting-started/quickstart).
