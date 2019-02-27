# Makefile for kni-edge deployments
#
AWS_LAUNCHER      = ./aws/launch_deploy.sh
CLUSTER_DESTROYER = ./destroy_cluster.sh
BUILDDIR          = build

ifndef INSTALLER_PATH
override INSTALLER_PATH = https://github.com/openshift/installer/releases/download/v0.13.0/openshift-install-linux-amd64
endif

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  aws-1-node CREDENTIALS=<github_repo> SETTINGS=<path_to_site_settings> to launch a deployment for aws in 1 node"
	@echo "  aws-3-node CREDENTIALS=<github_repo> SETTINGS=<path_to_site_settings> to launch a deployment for aws in 3 node"
	@echo "  clean to destroy a previously created cluster and remove build contents"

aws-1-node:
	@echo
	@echo "Launching aws 1-node deploy"
	${AWS_LAUNCHER} 1-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

aws-3-node:
	@echo
	@echo "Launching aws 3-node deploy"
	${AWS_LAUNCHER} 3-node ${BUILDDIR} ${CREDENTIALS} ${SETTINGS} ${INSTALLER_PATH}

clean:
	@echo
	@echo "Destroying previous cluster"
	${CLUSTER_DESTROYER} ${BUILDDIR}
