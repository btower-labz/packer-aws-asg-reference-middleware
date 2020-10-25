#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

source packer-vars.sh

export AWS_REGION=${PACKER_REGION}

aws sts get-caller-identity --profile ${PACKER_PROFILE}

packer validate packer.json
packer inspect packer.json
date;
packer build packer.json
date;
