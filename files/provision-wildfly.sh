#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

BASENAME=$(basename "${0}")

function log {
  local MESSAGE=${1}
  echo "${BASENAME}: ${MESSAGE}"
  logger --id "${BASENAME}: ${MESSAGE}"
}

log 'Started ...'

groupadd -r wildfly
useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly

log 'User created ...'

export WILDFLY_SRC=/usr/local/src/wildfly
export WILDFLY_DST=/opt
export WILDFLY_TAG=20.0.1.Final
export WILDFLY_URL=https://download.jboss.org/wildfly/${WILDFLY_TAG}/wildfly-${WILDFLY_TAG}.tar.gz
export WILDFLY_PKG=wildfly-${WILDFLY_TAG}.tar.gz

mkdir -p ${WILDFLY_SRC}
curl --location --silent -o ${WILDFLY_SRC}/${WILDFLY_PKG} ${WILDFLY_URL}
tar xf ${WILDFLY_SRC}/${WILDFLY_PKG} -C ${WILDFLY_DST}/
ls -la ${WILDFLY_DST}/wildfly-${WILDFLY_TAG}
ln -s ${WILDFLY_DST}/wildfly-${WILDFLY_TAG} ${WILDFLY_DST}/wildfly

log 'Files unpacked ...'

chown -RH wildfly: ${WILDFLY_DST}/wildfly

log 'Permissions fixed ...'

mkdir -p /etc/wildfly
cp ${WILDFLY_DST}/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/

log 'Configuration updated ...'

cp ${WILDFLY_DST}/wildfly/docs/contrib/scripts/systemd/launch.sh ${WILDFLY_DST}/wildfly/bin/
chmod +x ${WILDFLY_DST}/wildfly/bin/*.sh
cp ${WILDFLY_DST}/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/

log 'Daemon files updated ...'

systemctl daemon-reload
systemctl start wildfly
systemctl status wildfly

# TODO: WildFly Sanity checks

log 'Demon enabled ...'

systemctl stop wildfly
systemctl disable wildfly

log 'Daemon disabled ...'

# TODO: Clean wildfly packer produces logs

cd ${WILDFLY_DST}/wildfly && rm -rf ${WILDFLY_SRC}

log 'Finished ...'
