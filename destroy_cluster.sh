#!/bin/bash

BUILDDIR="$1"
pushd ${BUILDDIR}
./openshift-installer destroy cluster
popd
rm -rf ${BUILDDIR}
