# Makefile for kni-edge deployments
#
AWS_LAUNCHER      = ./aws/launch_deploy.sh
LIBVIRT_LAUNCHER  = ./libvirt/launch_deploy.sh
CLUSTER_DESTROYER = ./destroy_cluster.sh
IMAGE_BUILDER     = ./baremetal/build_images.sh
INSTALLER_BUILDER  = ./hack/build.sh
BUILDDIR          = build
INSTALLER_GIT_REPO = https://github.com/openshift/installer

ifndef INSTALLER_PATH
override INSTALLER_PATH = https://github.com/openshift/installer/releases/download/v0.13.0/openshift-install-linux-amd64
endif

ifndef INSTALLER_GIT_TAG
override INSTALLER_GIT_TAG = "v0.13.1"
endif

ifndef GOPATH
override GOPATH = "${HOME}/go/src"
endif

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  aws-1-node CREDENTIALS=<github_repo> SETTINGS=<path_to_site_settings> to launch a deployment for aws in 1 node"
	@echo "  aws-3-node CREDENTIALS=<github_repo> SETTINGS=<path_to_site_settings> to launch a deployment for aws in 3 node"
	@echo "  libvirt-1-node CREDENTIALS=<github_repo> SETTINGS=<path_to_site_settings> to launch a deployment for libvirt in 1 node"
	@echo "  clean to destroy a previously created cluster and remove build contents"
	@echo "  binary to generate a new openshift-install binary"

aws-1-node:
	@echo
	@echo "Launching aws 1-node deploy"
	${AWS_LAUNCHER} 1-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

aws-3-node:
	@echo
	@echo "Launching aws 3-node deploy"
	${AWS_LAUNCHER} 3-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

libvirt-1-node:
	@echo
	@echo "Launching libvirt 1-node deploy"
	${LIBVIRT_LAUNCHER} 1-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

libvirt-3-node:
	@echo
	@echo "Launching libvirt 3-node deploy"
	${LIBVIRT_LAUNCHER} 3-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

pxe-images:
	@echo
	@echo "Building PXE images for baremetal (only for internal Red Hat use)"
	${IMAGE_BUILDER} ${BUILDDIR}

binary:
	@echo
	@echo "Building installer binary"
	${INSTALLER_BUILDER} ${BUILDDIR} ${INSTALLER_GIT_REPO} ${INSTALLER_GIT_TAG} ${GOPATH}

clean:
	@echo
	@echo "Destroying previous cluster"
	${CLUSTER_DESTROYER} ${BUILDDIR}
