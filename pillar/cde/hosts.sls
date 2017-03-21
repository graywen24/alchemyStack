hosts:
  wess-a1:
    ip4: 8
    partitions: partbig
    no_maas: True
    network:
      manage:
        mac: 44:A8:42:2E:7F:DA
    roles:
      - containerhost
      - ntp
      - saltmaster
  wess-a2:
    ip4: 9
    partitions: partbig
    network:
      manage:
        mac: FA:16:3E:99:A4:EF
    roles:
      - containerhost
      - ntp
  ess-a3:
    ip4: 12
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:74:CE
    roles:
      - containerhost
      - ntp
  ess-a4:
    ip4: 13
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:74:F2
    roles:
      - containerhost
      - ntp
