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
if [ ! -f "${BUILDDIR}/openshift-installer" ]; then
    echo "Downloading openshift installer"
    curl -L ${INSTALLER_PATH} -o ${BUILDDIR}/openshift-installer
    chmod a+x ${BUILDDIR}/openshift-installer
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
EOF

# merge values and generate finall install-config
echo "Generating final install file"
j2 -f yaml ./libvirt/${FOOTPRINT_TYPE}/install-config.yaml ${BUILDDIR}/settings.yaml > ${BUILDDIR}/install-config.yaml

# launch the installer
echo "Launching installer"
pushd ${BUILDDIR}
./openshift-installer create cluster
popd
