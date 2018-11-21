# anchore-local

https://hub.docker.com/r/anchore/anchore-engine/

Local Docker containers vulnerability scan.
Create the following container with docker-compose
- private container registry
- anchore-cli server
- postgres (CVE data)

## required

- /etc/hosts or https://github.com/cbednarski/hostess
- add `anchore-registry.local  127.0.0.1`

## help

```shell
$ make help
```

## Quick Start

```shell
# docker up
$ make up
$ make status
Service apiext (dockerhostid-anchore-engine, http://anchore-engine:8228): up
Service kubernetes_webhook (dockerhostid-anchore-engine, http://anchore-engine:8338): up
Service simplequeue (dockerhostid-anchore-engine, http://anchore-engine:8083): up
Service analyzer (dockerhostid-anchore-engine, http://anchore-engine:8084): up
Service policy_engine (dockerhostid-anchore-engine, http://anchore-engine:8087): up
Service catalog (dockerhostid-anchore-engine, http://anchore-engine:8082): up

Engine DB Version: 0.0.8
Engine Code Version: 0.3.0

# after a few hour. vulnerability updates
# if you check amount of CVE data on postgres
$ make cve-status
Feed                   Group                  LastSync                          RecordCount
vulnerabilities        alpine:3.3             2018-11-21T11:16:12.825791        457
vulnerabilities        alpine:3.4             2018-11-21T11:16:22.173058        594
vulnerabilities        alpine:3.5             2018-11-21T11:16:36.250242        857
vulnerabilities        alpine:3.6             2018-11-21T11:16:50.463347        871
```

### global images scan

```shell
# Scan
$ make check IMAGE=golang:1.10
$ make progress IMAGE=golang:1.10
Analysis Status: analyzing

# If progress becomes analyzed
$ make vuln IMAGE=golang:1.10
$ make result IMAGE=golang:1.10
```

### local images scan

```
# push privcate registry
$ docker images
$ make push IMAGE=foobar:latest

# Scan
$ make check IMAGE=anchore-registry.local/foobar:latest
$ make progress IMAGE=anchore-registry.local/foobar:latest
Analysis Status: analyzing

# If progress becomes analyzed
$ make vuln IMAGE=anchore-registry.local/foobar:latest
$ make result IMAGE=anchore-registry.local/foobar:latest
```

### clean
```shell
# byebye anchore-local
$ make down

# clean
$ make clean
```

## etc

- docker compose file from https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/docker-compose.yaml
- docker config file based from https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml
