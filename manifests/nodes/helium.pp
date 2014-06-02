# Helium - DNS server
node helium inherits default {
  # bind stuff
  include bind

  bind::server::conf { '/etc/named.conf':
    listen_on_addr    => [ $dns_listen_on_addr ],
    listen_on_v6_addr => [ $dns_listen_on_addr ],
    forwarders        => [ $dns_forwarder ],
    allow_query       => [ $dns_allow_query ],
    zones             => {
      'chem.net'
        => [
          'type master',
          'file "chem.net"',
        ],
      '56.168.192.in-addr.arpa'
        => [
          'type master',
          'file "56.168.192.in-addr.arpa"',
        ],
    },
  }

  bind::server::file { 'chem.net':
    source => '/etc/puppet/files/chem.net',
  }

  bind::server::file { '56.168.192.in-addr.arpa':
    source => '/etc/puppet/files/56.168.192.in-addr.arpa',
  }

  #bind utils
  package { 'bind-utils':
    ensure => installed,
  }

  # Serverspec dns tests require the nameserver to be set correctly (to localhost)
  file { "/etc/resolv.conf":
    owner   => root,
    group   => root,
    mode    => 644,
    content => '/etc/puppet/files/resolv.conf',
  }

}