mine_functions:
  network.interfaces:
    interface: eth0
  network.ip_addrs:
    cidr: '10.0.32.0/24'
  workspace:
    - mine_function: grains.get
    - workspace