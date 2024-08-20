# Setup Podman in Arch Linux

require package `podman`

`/etc/containers/registries.conf.d/10-unqualified-search-registries.conf`

```bash
unqualified-search-registries = ["docker.io"]
```

```bash
# usermod --add-subuids 100000-165535 --add-subgids 100000-165535 username
# usermod --add-subuids 524288-589823 --add-subgids 524288-589823 username
```

```bash
DOCKER_BUILDKIT=0
```
