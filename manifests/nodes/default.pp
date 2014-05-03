node default {

  $domain_name = hiera('dns::domain')

  # vars
  $dns_domain = hiera('dns::domain')
  $dns_reverse_domain = hiera('dns::reverse_domain')
  $dns_forwarder = hiera('dns::forwarder')
  $dns_listen_on_addr = hiera('dns::listen_on_addr')
  $dns_allow_query = hiera('dns::allow_query')

  $network_ip = hiera('network::ip')
  $network_mask = hiera('network::mask')
  $network_cidr = hiera('network::cidr')

  $dhcp_default_gateway = hiera('dhcp::default_gateway')
  $dhcp_host_range = hiera('dhcp::host_range')
  $dhcp_hosts_hostname = 'neon'
  $dhcp_hosts = hiera('dhcp::hosts')
  #end of vars

  notice("I'm node ${::hostname} in ${domain_name} with IP ${::ipaddress_eth1}")

}
