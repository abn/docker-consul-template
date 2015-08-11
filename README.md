# Consul Template Container

This project puts [Consul Template](https://github.com/hashicorp/consul-template) in scratch docker container. It is available on [Docker Hub](https://registry.hub.docker.com/u/alectolytic/consul-template/) and can be pulled using the following command.

```sh
docker pull alectolytic/consul-template
```

You will note that this is a tiny image.
```
$ docker images | grep docker.io/alectolytic/consul-template
docker.io/alectolytic/consul-template  90424465fa2f  12 minutes ago  6.495 MB
```

## Quickstart

#### Default

```sh
docker run --rm -it alectolytic/consul-template
```

#### Configuration file

```sh
docker run --rm -it \
  -v /path/to/config.json:/config.json \
  alectolytic/consul-template -config=/config.json
```

**NOTE:** If running on an SELinux enabled system, run `chcon -Rt svirt_sandbox_file_t /path/to/config.json` before staring consul.

#### Persisted Templates

```sh
# create data volume
docker create  --entrypoint=_ -v /templates --name templates scratch

# run consul-template with the data volume
docker run --rm -it \
  --volumes-from templates \
  alectolytic/consul-template
```
