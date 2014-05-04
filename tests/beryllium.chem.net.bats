#! /usr/bin/env bats
# Vim: set ft=sh
#
# Test suite for beryllium.chem.net, a DHCP server
#

IP=192.168.56.4

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