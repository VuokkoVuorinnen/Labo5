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

# Correct hostname set
@test "my hostname should be beryllium.chem.net" {
        result="$(hostname -f)"
        [  "$?" -eq 0 ]                   # exit status should be 0
        [  "${result}" == "beryllium.chem.net" ] # the result should be the correct hostname
}

# Test package installed
@test "package dhcp should be installed" {
	result="$(rpm -q dhcp)"
	[ "$?" -eq 0 ]   # Exit status should be 0
	# If the package is installed, this regex will not match
	[[ ! "${result}" =~ 'not installed' ]]
}

# Test service enabled
@test "dhcpd should be running" {
	result="$(service dhcpd status | grep '^dhcpd.*is running\.\.\.$')"
	[ "$?" -eq 0 ]     # exit status should be 0
	[ -n "${result}" ] # output should not be empty
}

@test "service dhcpd should start at boot" {
	result="$(chkconfig | grep dhcpd | grep on)"
        [ "$?" -eq 0 ]     # exit status should be 0
        [ -n "${result}" ] # output should not be empty
}

# Test ports open
@test "port 67 should be listening on UDP" {
	result="$(netstat -lnu | awk '$4 ~ ":67"')"
	[ "$?" -eq 0 ]     # exit status should be 0
	[ -n "${result}" ] # output should not be empty
}

@test "port 68 should be listening on UDP" {
	result="$(netstat -lnu | awk '$4 ~ ":68"')"
	[ "$?" -eq 0 ]     # exit status should be 0
	[ -n "${result}" ] # output should not be empty
}

# Test config file correct