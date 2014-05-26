require 'spec_helper'

# Install necessary packages: bind and bind-utils (the latter for testing with
# the host command)
describe package('bind') do
	it { should be_installed }
end

describe package('bind-utils') do
	it { should be_installed }
end

# Check config files

CONF = '/etc/named.conf'
ZONE = 'chem.net'
ZONE_FILE = '/var/named/chem.net'
REVERSE_ZONE = '56.168.192.in-addr.arpa'
REVERSE_ZONE_FILE = '/var/named/56.168.192.in-addr.arpa'

describe file(CONF) do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match 'zone.*chem.net' }
  its(:content) { should match 'zone.*56.168.192.in-addr.arpa'}
end

describe command('named-checkconf') do
	it { should return_exit_status 0 }
end

describe file (ZONE_FILE) do
	it { should be_file }
	it { should be_mode 640 }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'named' }
end

describe file (REVERSE_ZONE_FILE) do
	it { should be_file }
	it { should be_mode 640 }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'named' }
end

describe command("named-checkzone #{ZONE}. #{ZONE_FILE} | tail -1") do
	it { should return_exit_status 0 }
	it { should return_stdout 'OK' }
end

describe command("named-checkzone #{REVERSE_ZONE}. #{REVERSE_ZONE_FILE} | tail -1") do
	it { should return_exit_status 0 }
	it { should return_stdout 'OK' }
end

# Check service

describe port(53) do
	it { should be_listening.with('tcp') }
	it { should be_listening.with('udp') }
end

describe service('named') do
	it { should be_running }
	it { should be_enabled }
end

# Interact with the DNS server, ask for all A, CNAME, SRV, PTR records

describe host('hydrogen.chem.net') do
  its(:ipaddress) { should eq '192.168.56.1' }
  it { should be_resolvable.by('dns') }
end

describe host('helium.chem.net') do
#  its(:ipaddress) { should eq '192.168.56.2' }
  its(:ipaddress) { should eq '127.0.0.1' }
  it { should be_resolvable.by('dns') }
end

describe host('lithium.chem.net') do
  its(:ipaddress) { should eq '192.168.56.3' }
  it { should be_resolvable.by('dns') }
end

describe host('beryllium.chem.net') do
  its(:ipaddress) { should eq '192.168.56.4' }
  it { should be_resolvable.by('dns') }
end

describe host('boron.chem.net') do
  its(:ipaddress) { should eq '192.168.56.5' }
  it { should be_resolvable.by('dns') }
end

describe host('carbon.chem.net') do
  its(:ipaddress) { should eq '192.168.56.6' }
  it { should be_resolvable.by('dns') }
end

describe host('nitrogen.chem.net') do
  its(:ipaddress) { should eq '192.168.56.7' }
  it { should be_resolvable.by('dns') }
end

describe host('oxygen.chem.net') do
  its(:ipaddress) { should eq '192.168.56.8' }
  it { should be_resolvable.by('dns') }
end

describe host('fluorine.chem.net') do
  its(:ipaddress) { should eq '192.168.56.9' }
  it { should be_resolvable.by('dns') }
end

describe host('neon.chem.net') do
  its(:ipaddress) { should eq '192.168.56.10' }
  it { should be_resolvable.by('dns') }
end

describe host('ns1.chem.net') do
  its(:ipaddress) { should eq '192.168.56.2' }
  it { should be_resolvable.by('dns') }
end

describe host('ns2.chem.net') do
  its(:ipaddress) { should eq '192.168.56.3' }
  it { should be_resolvable.by('dns') }
end

describe host('www.chem.net') do
  its(:ipaddress) { should eq '192.168.56.5' }
  it { should be_resolvable.by('dns') }
end

describe host('mail-in.chem.net') do
  its(:ipaddress) { should eq '192.168.56.6' }
  it { should be_resolvable.by('dns') }
end

describe host('mail-out.chem.net') do
  its(:ipaddress) { should eq '192.168.56.6' }
  it { should be_resolvable.by('dns') }
end

IP='192.168.56.2'

describe command("host #{ZONE} #{IP} | grep mail") do
  it { should return_exit_status 0 }
  it { should return_stdout "#{ZONE} mail is handled by 10 carbon.#{ZONE}." }
end

describe command("host -t SRV _ftp._tcp.#{ZONE} #{IP} | grep SRV") do
  it { should return_exit_status 0}
  its(:stdout) { should match /10 0 21 nitrogen.chem.net/ }
end

NET_IP='192.168.56'

describe command("host #{NET_IP}.1 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "1.#{REVERSE_ZONE} domain name pointer hydrogen.chem.net." }
end

describe command("host #{NET_IP}.2 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "2.#{REVERSE_ZONE} domain name pointer helium.chem.net." }
end

describe command("host #{NET_IP}.3 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "3.#{REVERSE_ZONE} domain name pointer lithium.chem.net." }
end

describe command("host #{NET_IP}.4 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "4.#{REVERSE_ZONE} domain name pointer beryllium.chem.net." }
end

describe command("host #{NET_IP}.5 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "5.#{REVERSE_ZONE} domain name pointer boron.chem.net." }
end

describe command("host #{NET_IP}.6 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "6.#{REVERSE_ZONE} domain name pointer carbon.chem.net." }
end

describe command("host #{NET_IP}.7 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "7.#{REVERSE_ZONE} domain name pointer nitrogen.chem.net." }
end

describe command("host #{NET_IP}.8 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "8.#{REVERSE_ZONE} domain name pointer oxygen.chem.net." }
end

describe command("host #{NET_IP}.9 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "9.#{REVERSE_ZONE} domain name pointer fluorine.chem.net." }
end

describe command("host #{NET_IP}.10 #{IP} | grep pointer") do
  it { should return_exit_status 0 }
  it { should return_stdout "10.#{REVERSE_ZONE} domain name pointer neon.chem.net." }
end
