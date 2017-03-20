lxc.container_profile:
  ubuntu:
    template: ubuntu-alchemy
    options:
      arch: amd64
      release: trusty
      mirror: http://10.0.32.8/cde/ubuntu
      security-mirror: http://10.0.32.8/cde/ubuntu
  cde-bootstrap:
    template: ubuntu-alchemy
    resolver: False
    options:
      arch: amd64
      release: trusty
      mirror: http://10.0.32.8/cde/ubuntu
      security-mirror: http://10.0.32.8/cde/ubuntu
      repoip: 10.0.32.8
      profile: cde-bootstrap
