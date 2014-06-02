#! /usr/bin/env bats
# Vim: set ft=sh
#
# Test suite for neon.chem.net, a client
#

IP=192.168.56.10

@test "my IP address should be ${IP}" {
	result="$(facter ipaddress_eth1)"
	[ "$?" -eq 0 ]     # exit status should be 0
	[ "${result}" = "${IP}" ]
}

# I need ssh!
@test "port 22 should be listening" {
	result="$(netstat -lnt | awk '$6 == "LISTEN" && $4 ~ ":22"')"
	[ "$?" -eq 0 ]     # exit status should be 0
	[ -n "${result}" ] # output should not be empty
}

@test "/etc/resolv.conf should contain correct DNS server" {
    result="$(cat /etc/resolv.conf | grep 'nameserver 192.168.56.2')"
    [ "$?" -eq 0 ]     # exit status should be 0
    [ -n "$result" ]   # output should not be empty
}