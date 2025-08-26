## Dockerfiles
* pinning base image versions: soemthing like alpine:3.21 means you will still get security patches when you rebuild. It might first point to 3.21.1, then later to 3.21.3 for example. 

## Compose
* after changing Dockerfile, run 'docker compose build' and only after that 'docker compose up'

## .dockerignore
* only needed to protect files/dirs that are in the build path of compose

## Other
* containers can reach eachother on the bridge network using container names as hostnames

## Scripts
* To ensure we are running as PID 1: `#!/bin/sh exec nginx`
