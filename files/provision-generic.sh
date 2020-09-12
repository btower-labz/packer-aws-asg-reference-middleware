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

# See: https://aws.amazon.com/premiumsupport/knowledge-center/ec2-install-extras-library-software/
yum install -y amazon-linux-extras
yum -y clean metadata && yum --assumeyes install unzip curl wget

log 'Finished ...'
