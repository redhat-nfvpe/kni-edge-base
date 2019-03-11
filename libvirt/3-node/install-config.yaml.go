apiVersion: v1beta3
baseDomain: {{ .baseDomain }}
compute:
- name: worker
  platform: {}
  replicas: 3
controlPlane:
  name: master
  platform: {}
  replicas: 3
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
    network:
      if: tt0
pullSecret: '{{ .pullSecret }}'
sshKey: |
  {{ .SSHKey }}
