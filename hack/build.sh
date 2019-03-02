#!/bin/bash

BUILDDIR=$(pwd)/$1
INSTALLER_REPO="$2"
INSTALLER_TAG="$3"
GOPATH="$4"

# create directory
if [ ! -d "${BUILDDIR}" ]; then
    mkdir ${BUILDDIR}
fi

# clone installer with specific tag
INSTALLER_SRC_PATH="${GOPATH}/github.com/openshift/"
if [ ! -d "${INSTALLER_SRC_PATH}" ]; then
    mkdir -p "${INSTALLER_SRC_PATH}"
fi
pushd "${INSTALLER_SRC_PATH}"

if [ -d "installer" ]; then
    rm -rf installer
fi

git clone "${INSTALLER_REPO}" -b "${INSTALLER_TAG}" "${INSTALLER_SRC_PATH}/installer"

pushd installer

# generate the installer
TAGS=libvirt hack/build.sh

if [ $? -ne 0 ]; then
    echo "There has been a failure generating the openshift installer"
    exit 1
else
    # copy final installer to build directory
    cp ./bin/openshift-install ${BUILDDIR}/
fi

popd
popd

