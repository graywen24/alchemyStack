{% set gateway = salt['pillar.get']('lxchost:address', '10.0.4.254') -%}
{% set iface = salt['pillar.get']('lxchost:iface', 'lxcbr0') -%}
{% set lease_time = salt['pillar.get']('lxchost:lease_time', '15m') -%}
{% set nameservers = salt['pillar.get']('lxchost:nameservers', ['8.8.8.8']) -%}
{% set netmask = salt['pillar.get']('lxchost:netmask', '255.255.255.0') -%}
{% set network = salt['pillar.get']('lxchost:network', '10.0.4.0') -%}
{% set range = salt['pillar.get']('lxchost:range', '10.0.4.1,10.0.4.250') -%}
{% set etcdir = salt['pillar.get']('lxchost:etcdir', '/etc/lxc') -%}


# make sure we have loop in the modules file!


lxc_pkgs:
  pkg.installed:
    - pkgs:
      - bridge-utils
      - dnsmasq
      - iptables
      - lxc
    - install_recommends: False
    - reload_modules: True

disable_dnsmasq:
  service.dead:
    - name: dnsmasq
    - enable: False

conf_sysctl:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

etclxc:
  file.directory:
    - name: {{ etcdir }}

default:
  file.managed:
    - name: {{ etcdir }}/default.conf
    - source: salt://lxchost/lxc.conf
    - template: jinja
    - defaults:
        bridge: {{ iface }}

conf_lxc_dnsmasq:
  file.managed:
    - name: {{ etcdir }}/dnsmasq.conf
    - source: salt://lxchost/dnsmasq.conf
    - template: jinja
    - defaults:
        range: {{ range }}
        lease_time: {{ lease_time }}

interfaces-d:
  file.directory:
    - name: /etc/network/interfaces.d
    - mode: 0755

source-interfaces-d:
  file.append:
    - name: /etc/network/interfaces
    - text: source-directory interfaces.d

interface-file:
  file.managed:
    - name: /etc/network/interfaces.d/lxchost
    - source: salt://lxchost/interfaces
    - template: jinja
    - mode: 0644
    - defaults:
        address: {{ gateway }}
        iface: {{ iface }}
        network: {{ network }}
        netmask: {{ netmask }}
        nameservers:
{%- for nameserver in nameservers %}
          - {{ nameserver }}
{%- endfor %}

down_{{ iface }}:
  cmd.wait:
    - name: ifdown {{ iface }}
    - watch:
      - file: interface-file
    - onlyif: test -f /sys/devices/virtual/net/{{ iface }}/bridge/bridge_id

up_{{ iface }}:
  cmd.wait:
    - name: ifup {{ iface }}
    - watch:
      - file: interface-file
