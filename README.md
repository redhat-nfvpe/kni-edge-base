## KNI Templates

This repository is meant to gather templates for the Kubernetes Native
Infrastructure model. These templates represent a way to declare descriptive
infrastructure across several footprints (AWS, Libvirt, Baremetal, etc).

## Dependencies

You will need to create a CoreOS account on [http://account.coreos.com/](http://account.coreos.com/)
This is needed to have download access to the OpenShift installer artifacts.
After that, you will need to download the Pull Secret, and format it in 1-line
style.

    { "auths": { "quay.io": { "auth": "XXX", "email": "" } } }


## How to deploy

There is a Makefile on the root directory of this project. In order to deploy
you will need to use the following syntax:

    make <target> CREDENTIALS=<path_to_private_repo> SETTINGS=file:///<path_to_sample_settings>

**Content of private repo**

This repository is needed to store private credentials. It is recommended that
you store those credentials on a private repo where only allowed people have
access. Each setting is stored in individual files in the repository:

- ssh-pub-key           # public key to be used for SSH access into the nodes
- coreos-pull-secret    # place the file that you created before
- aws-access-key-id     # just for AWS deploy, key id that you created in AWS
- aws-secret-access-key # just for AWS deploy, secret for the key id

## How to deploy for AWS

Before starting the deploy, please read the following documentation to prepare
the AWS account properly:
[https://github.com/openshift/installer/blob/master/docs/user/aws/README.md](https://github.com/openshift/installer/blob/master/docs/user/aws/README.md)

One of the targets for Makefile is AWS cloud. There are two different
footprints: 1 master/1 worker, and 3 masters/3 workers. So two targets exist:
1-node and 3-node. So makefile needs to be called with:

    make [aws-1-node|aws-3-node] CREDENTIALS=<path_to_private_repo> SETTINGS=file:///<path_to_sample_settings>

A sample settings.yaml file has been created specifically for AWS targets. It
needs to look like:

    settings:
      baseDomain: "<base_domain>"
      clusterName: "<cluster_name>"
      clusterCIDR: "10.128.0.0/14"
      clusterSubnetLength: 9
      machineCIDR: "10.0.0.0/16"
      serviceCIDR: "172.30.0.0/16"
      SDNType: "OpenShiftSDN"
      AWSRegion: "<aws_region_to_deploy>"

Where:
- `<base_domain>` is the DNS zone matching with the one created on Route53
- `<cluster_name>` is the name you are going to give to the cluster
- `<aws_region_to_deploy>` is the region where you want your cluster to deploy

SETTINGS can be a path to local file, or an url, will be queried with curl.

The make process will create the needed artifacts and will start the deployment
of the specified cluster

## How to destroy the cluster

In order to destroy the running cluster, and clean up environment, just use
`make clean` command.

## Building and consuming your own installer

The openshift-installer binaries are published on
https://github.com/openshift/installer/releases. For faster deploy, you can grab
the instalelr from here. However, there may be situations where you need to
compile your own installer (such as the case of libvirt), or you need a newer
version. In that case, you can build it following the instructions on
[https://github.com/openshift/installer](https://github.com/openshift/installer)

Then you can export the path to the new installer before running make:

    export INSTALLER_PATH=http://<url_to_binary>/openshift-install

