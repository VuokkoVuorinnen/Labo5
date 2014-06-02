require 'spec_helper'

describe interface('eth1') do
	it { should have_ipv4_address("192.168.56.4") }
end

describe command('hostname -f') do
	it { should return_stdout 'beryllium.chem.net' }
end

describe port(22) do
  it { should be_listening.with('tcp') }
end

describe package('dhcp') do
	it { should be_installed }
end

describe service('dhcpd') do
	it { should be_enabled }
	it { should be_running }
end

describe port(67) do
	it { should be_listening.with('udp') }
end

describe port(68) do
	it { should be_listening.with('udp') }
end

describe file('/etc/dhcp/dhcpd.hosts') do
	its(:content) { should match /host neon/ }
	its(:content) { should match /hardware ethernet   08:00:27:70:8d:b3;/ }
	its(:content) { should match /fixed-address       192.168.56.10;/ }
end

describe file('/etc/dhcp/dhcpd.pools') do
	its(:content) { should match /range 192.168.56.101 192.168.56.254;/ }
end