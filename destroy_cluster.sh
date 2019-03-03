#!/bin/bash

BUILDDIR="$1"

if [ ! -d "${BUILDDIR}" ]; then
    echo "Cannot destroy cluster, build directory does not exist"
    exit 0
fi

pushd ${BUILDDIR}
./openshift-install destroy cluster

RESULT=$?

popd

if [ $RESULT -eq 0 ]; then
    rm -rf ${BUILDDIR}
fi
