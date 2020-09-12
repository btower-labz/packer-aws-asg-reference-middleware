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

# See: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/amazon-linux-install.html
yum -y install java-11-amazon-corretto

log 'Finished ...'
