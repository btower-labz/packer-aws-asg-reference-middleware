#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

BASENAME=$(basename "${0}")
DOCKER_COMPOSE_VERSION=1.27.4

function log {
  local MESSAGE=${1}
  echo "${BASENAME}: ${MESSAGE}"
  logger --id "${BASENAME}: ${MESSAGE}"
}

log 'Started ...'

yum update -y

log 'Installing docker ...'

yum install -y amazon-linux-extras
amazon-linux-extras enable docker
yum install -y docker
systemctl enable docker
systemctl start docker
docker info

log 'Patching user ...'
usermod -a -G docker ec2-user

log 'Installing docker compose ...'

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose-${DOCKER_COMPOSE_VERSION}
chmod +x /usr/local/bin/docker-compose-${DOCKER_COMPOSE_VERSION}
ln -s /usr/local/bin/docker-compose-${DOCKER_COMPOSE_VERSION} /usr/bin/docker-compose
docker-compose --version

log 'Finished ...'
