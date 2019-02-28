#!/bin/bash

BUILDDIR="$1"
pushd ${BUILDDIR}
./openshift-install destroy cluster

RESULT=$?

popd

if [ $RESULT -eq 0 ]; then
    rm -rf ${BUILDDIR}
fi
