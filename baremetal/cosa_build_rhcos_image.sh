#!/bin/bash

# first retrieve the certificates
sudo curl -kL -o /etc/pki/ca-trust/source/anchors/Red_Hat_IT_Root_CA.crt https://password.corp.redhat.com/RH-IT-Root-CA.crt
sudo update-ca-trust

# we have to override the install ISO used because of https://github.com/coreos/coreos-assembler/issues/325
export INSTALLER_URL_OVERRIDE=http://download.devel.redhat.com/released/F-28/GOLD/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-28-1.1.iso
export INSTALLER_CHECKSUM_URL_OVERRIDE=http://download.devel.redhat.com/released/F-28/GOLD/Everything/x86_64/iso/Fedora-Everything-28-1.1-x86_64-CHECKSUM

# init the build and proceed
cd /srv
coreos-assembler init https://gitlab.cee.redhat.com/yroblamo/redhat-coreos.git maipo --force

(cd src/config-git && make prep)
coreos-assembler build
coreos-assembler buildextend-installer
