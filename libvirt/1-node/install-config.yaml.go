apiVersion: v1beta3
baseDomain: {{ .baseDomain }}
compute:
- name: worker
  platform: {}
  replicas: 1
controlPlane:
  name: master
  platform: {}
  replicas: 1
metadata:
  creationTimestamp: null
  name: {{ .clusterName }}
networking:
  clusterNetworks:
  - cidr: {{ .clusterCIDR }}
    hostSubnetLength: {{ .clusterSubnetLength }}
  machineCIDR: {{ .machineCIDR }}
  serviceCIDR: {{ .serviceCIDR }}
  type: {{ .SDNType }}
platform:
  libvirt:
    URI: {{ .libvirtURI }}
pullSecret: '{{ .pullSecret }}'
sshKey: |
  {{ .SSHKey }}
