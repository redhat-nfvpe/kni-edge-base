#!/bin/bash

shopt -s expand_aliases
BUILDDIR=$(pwd)/$1

# generate build directory
if [ -d $BUILDDIR/cosa_build ]; then
    rm -rf $BUILDDIR/cosa_build
fi

if [ ! -d $BUILDDIR/cosa_build ]; then
    mkdir $BUILDDIR/cosa_build
fi
chmod 0775 $BUILDDIR/cosa_build
cp ./baremetal/cosa_build_rhcos_image.sh $BUILDDIR/cosa_build/

# Install coreos-assembler
echo "Installing coreos assembler"
alias coreos-assembler="podman run --rm --net=host -ti --privileged --userns=host -v $BUILDDIR/cosa_build:/srv --workdir /srv quay.io/coreos-assembler/coreos-assembler:latest"
coreos-assembler shell /srv/cosa_build_rhcos_image.sh

# If image exists, convert to raw
if [ -f $BUILDDIR/cosa_build/builds/latest/redhat-coreos-maipo-47-qemu.qcow2 ]; then
    qemu-img convert $BUILDDIR/cosa_build/builds/latest/redhat-coreos-maipo-47-qemu.qcow2 $BUILDDIR/rhcos-qemu.raw
    gzip -c $BUILDDIR/rhcos-qemu.raw > $BUILDDIR/rhcos-qemu.raw.gz
else
    echo "Failed to generate qcow2 RHCOS image"
    exit 1
fi

# If iso exists, extract it
if [ -f $BUILDDIR/cosa_build/builds/latest/redhat-coreos-maipo-47.iso ]; then
    cp $BUILDDIR/cosa_build/builds/latest/redhat-coreos-maipo-47.iso $BUILDDIR/rhcos-qemu.iso
    mkdir -p $BUILDDIR/iso_mount
    mount -o loop $BUILDDIR/cosa_build/builds/latest/redhat-coreos-maipo-47.iso $BUILDDIR/iso_mount/
    cp $BUILDDIR/iso_mount/vmlinuz $BUILDDIR/vmlinuz
    cp $BUILDDIR/iso_mount/initramfs.img $BUILDDIR/initrd.img
    chmod a+r $BUILDDIR/initrd.img
else
    echo "Failed to generate pxe images"
    exit 1
fi

echo "Images are published on $BUILDDIR directory: rhcos-qemu.qcow2, rhcos-qemu.raw.gz, vmlinuz, initrd.img. Please copy them to a safe location"
