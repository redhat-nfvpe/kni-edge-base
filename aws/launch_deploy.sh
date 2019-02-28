#!/bin/bash

# first download the installer binary into BUILDDIR
FOOTPRINT_TYPE="$1"
BUILDDIR="$2"
PRIVATE_REPO="$3"
SETTINGS="$4"
INSTALLER_PATH="$5"

# create directory
if [ ! -d "${BUILDDIR}" ]; then
    mkdir ${BUILDDIR}
fi

# download installer
if [ ! -f "${BUILDDIR}/openshift-install" ]; then
    echo "Downloading openshift installer"
    curl -L ${INSTALLER_PATH} -o ${BUILDDIR}/openshift-install
    chmod a+x ${BUILDDIR}/openshift-install
fi

# install pip if it isn't installed
if ! [ -x "$(command -v pip)" ]; then
    echo "Installing python-pip"
    if [ ! -f "${BUIDDIR}/get-pip.py" ]; then
        curl https://bootstrap.pypa.io/get-pip.py -o ${BUILDDIR}/get-pip.py
    fi
    python ${BUILDDIR}/get-pip.py
fi

# install j2cli if not installed
echo "Installing j2cli"
pip -q install j2cli

# clone private repo with credentials
if [ ! -d "${BUILDDIR}/credentials" ]; then
   echo "Downloading credentials repo"
   git clone ${PRIVATE_REPO} ${BUILDDIR}/credentials
fi

# clone settings.yaml and place it on build directory
echo "Downloading settings from $SETTINGS"
curl ${SETTINGS} -o ${BUILDDIR}/settings.yaml

cat <<EOF >> ${BUILDDIR}/settings.yaml
  SSHKey: "$(cat ${BUILDDIR}/credentials/ssh-pub-key)"
  pullSecret: '$(cat ${BUILDDIR}/credentials/coreos-pull-secret)'
  AWSAccessKey: "$(cat ${BUILDDIR}/credentials/aws-access-key-id)"
  AWSSecretKey: "$(cat ${BUILDDIR}/credentials/aws-secret-access-key)"
EOF

# merge values and generate finall install-config
echo "Generating final install file"
j2 -f yaml ./aws/${FOOTPRINT_TYPE}/install-config.yaml ${BUILDDIR}/settings.yaml > ${BUILDDIR}/install-config.yaml

# generate file with AWS credentials
if [ ! -f "${HOME}/.aws/credentials" ]; then
    echo "Generating credentials file"
    if [ ! -d "${HOME}/.aws" ]; then
        mkdir ${HOME}/.aws
    fi
    j2 -f yaml ./aws/credentials_template ${BUILDDIR}/settings.yaml > ${HOME}/.aws/credentials
    chmod 0600 ${HOME}/.aws/credentials
fi

# launch the installer
echo "Launching installer"
pushd ${BUILDDIR}
./openshift-install create cluster
popd
