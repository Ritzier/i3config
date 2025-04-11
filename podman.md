# Setup Podman

## Needed Packages

Require packages:

```sh
pacman -S podman podman-compose fuse-overlayfs
```

## Registries

file: `/etc/containers/registries.conf.d/10-unqualified-search-registries.conf`

```conf
unqualified-search-registries = ["docker.io"]
```

## Rootless Podman

```sh
sudo usermod --add-subuids 100000-150000 --add-subgids 100000-150000 $USER
```
