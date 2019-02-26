#!/bin/bash

BUILDDIR="$1"
pushd ${BUILDDIR}
./openshift-installer destroy cluster

RESULT=$?

popd

if [ $RESULT -eq 0 ]; then
    rm -rf ${BUILDDIR}
fi
