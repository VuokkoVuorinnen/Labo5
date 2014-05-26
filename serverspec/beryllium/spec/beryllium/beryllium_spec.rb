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