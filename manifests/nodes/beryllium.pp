# Beryllium - DHCP server
#
node beryllium inherits default {

#notice("vartest ${dhcp_hosts[neon][ip]}")

  class { 'dhcp':
    dnsdomain    => [
      'dns.chem.net',
      $dns_reverse_domain,
    ],
    nameservers  => ['192.168.56.2'],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth0'],
  }

  dhcp::pool{ 'ops.chem.net':
    network => $network_ip,
    mask    => $network_mask,
    range   => $dhcp_host_range,
    gateway => $dhcp_default_gateway,
  }

  dhcp::host {
    'neon':
      mac => $dhcp_hosts[neon][mac],
      ip  => $dhcp_hosts[neon][ip];
  }
}
