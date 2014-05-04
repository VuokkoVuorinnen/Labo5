#! /usr/bin/env bats
# Vim: set ft=sh
#
# Test suite for helium.chem.net, a DNS server
#

IP=192.168.56.2

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

# Install necessary packages: bind and bind-utils (the latter for testing with
# the host command)
@test "package bind should be installed" {
result="$(rpm -q bind)"
[ "$?" -eq 0 ]   # Exit status should be 0
# If the package is installed, this regex will not match
[[ ! "${result}" =~ 'not installed' ]]
}

@test "package bind-utils should be installed" {
result="$(rpm -q bind-utils)"
[ "$?" -eq 0 ]   # Exit status should be 0
# If the package is installed, this regex will not match
[[ ! "${result}" =~ 'not installed' ]]
}

# Check config files

CONF=/etc/named.conf
ZONE=chem.net
ZONE_FILE=/var/named/${ZONE}
REVERSE_ZONE=56.168.192.in-addr.arpa
REVERSE_ZONE_FILE=/var/named/${REVERSE_ZONE}

@test "${CONF} should exist and have correct permissions" {
[ -f "${CONF}" ]
result="$(stat -c %U:%G:%a ${CONF})"
[ "$?" -eq 0 ]
[ "${result}" = "root:root:644" ]
}

@test "${CONF} should be syntactically correct" {
named-checkconf
}

@test "${CONF} should contain a zone definition" {
result="$(grep zone.*${ZONE} ${CONF})"
[ -n "${result}" ]
}

@test "${CONF} should contain a reverse zone definition" {
result="$(grep zone.*${REVERSE_ZONE} ${CONF})"
[ -n "${result}" ]
}

@test "BIND zone file for chem.net should exist and have correct permissions" {
[ -f "${ZONE_FILE}" ]
result="$(stat -c %U:%G:%a ${ZONE_FILE})"
[ "$?" -eq 0 ]
[ "${result}" = "root:named:640" ]
}

@test "BIND reverse zone file for chem.net should exist and have correct permissions" {
[ -f "${REVERSE_ZONE_FILE}" ]
result="$(stat -c %U:%G:%a ${REVERSE_ZONE_FILE})"
[ "$?" -eq 0 ]
[ "${result}" = "root:named:640" ]
}

@test "BIND zone file should be syntactically correct" {
result="$(named-checkzone ${ZONE}. ${ZONE_FILE} | tail -1)"
[ "$?" -eq 0 ]
[ "${result}" = "OK" ]
}

@test "BIND reverse zone file should be syntactically correct" {
result="$(named-checkzone ${REVERSE_ZONE}. ${REVERSE_ZONE_FILE} | tail -1)"
[ "$?" -eq 0 ]
[ "${result}" = "OK" ]
}

# Check service

@test "port 53 should be listening on TCP" {
result="$(netstat -lnt | awk '$6 == "LISTEN" && $4 ~ ":53"')"
[ "$?" -eq 0 ]     # exit status should be 0
[ -n "${result}" ] # output should not be empty
}

@test "port 53 should be listening on UDP" {
result="$(netstat -lnu | awk '$4 ~ ":53"')"
[ "$?" -eq 0 ]     # exit status should be 0
[ -n "${result}" ] # output should not be empty
}

@test "named should be running" {
result="$(service named status | grep '^named.*is running\.\.\.$')"
[ "$?" -eq 0 ]     # exit status should be 0
[ -n "${result}" ] # output should not be empty
}

# Interact with the DNS server, ask for all A, CNAME, SRV, PTR records

@test "Looking up hydrogen should return the correct address" {
result="$(host hydrogen.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.1" ]]
}


@test "Looking up helium should return the correct address" {
result="$(host helium.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.2" ]]
}

@test "Looking up lithium should return the correct address" {
result="$(host lithium.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.3" ]]
}

@test "Looking up beryllium should return the correct address" {
result="$(host beryllium.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.4" ]]
}

@test "Looking up boron should return the correct address" {
result="$(host boron.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.5" ]]
}

@test "Looking up carbon should return the correct address" {
result="$(host carbon.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.6" ]]
}

@test "Looking up nitrogen should return the correct address" {
result="$(host nitrogen.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.7" ]]
}

@test "Looking up oxygen should return the correct address" {
result="$(host oxygen.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.8" ]]
}

@test "Looking up fluorine should return the correct address" {
result="$(host fluorine.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.9" ]]
}

@test "Looking up neon should return the correct address" {
result="$(host neon.${ZONE} ${IP} | grep 'has address')"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "192.168.56.10" ]]
}

@test "Looking up alias ns1 should return the correct host" {
result="$(host ns1.${ZONE} ${IP} | grep alias)"
[[ "${result}" =~ "helium.${ZONE}" ]]
}

@test "Looking up alias ns2 should return the correct host" {
result="$(host ns2.${ZONE} ${IP} | grep alias)"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "lithium.${ZONE}" ]]
}

@test "Looking up alias www should return the correct host" {
result="$(host www.${ZONE} ${IP} | grep alias)"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "boron.${ZONE}" ]]
}

@test "Looking up alias mail-in should return the correct host" {
result="$(host mail-in.${ZONE} ${IP} | grep alias)"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "carbon.${ZONE}" ]]
}

@test "Looking up alias mail-out should return the correct host" {
result="$(host mail-out.${ZONE} ${IP} | grep alias)"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "carbon.${ZONE}" ]]
}

@test "Looking up domain name should return mail handler and level (10)" {
result="$(host ${ZONE} ${IP} | grep mail)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "${ZONE} mail is handled by 10 carbon.${ZONE}." ]
}

@test "Looking up service ftp should return the correct host and priority/weight/port (10 0 21)" {
result="$(host -t SRV _ftp._tcp.${ZONE} ${IP} | grep SRV)"
[ "$?" -eq 0 ]     # exit status should be 0
[[ "${result}" =~ "10 0 21 nitrogen.${ZONE}" ]]
}

NET_IP=192.168.56

@test "Looking up ${NET_IP}.1 should return the correct host" {
result="$(host ${NET_IP}.1 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "1.${REVERSE_ZONE} domain name pointer hydrogen.chem.net." ]
}

@test "Looking up ${NET_IP}.2 should return the correct host" {
result="$(host ${NET_IP}.2 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "2.${REVERSE_ZONE} domain name pointer helium.chem.net." ]
}

@test "Looking up ${NET_IP}.3 should return the correct host" {
result="$(host ${NET_IP}.3 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "3.${REVERSE_ZONE} domain name pointer lithium.chem.net." ]
}

@test "Looking up ${NET_IP}.4 should return the correct host" {
result="$(host ${NET_IP}.4 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "4.${REVERSE_ZONE} domain name pointer beryllium.chem.net." ]
}

@test "Looking up ${NET_IP}.5 should return the correct host" {
result="$(host ${NET_IP}.5 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "5.${REVERSE_ZONE} domain name pointer boron.chem.net." ]
}

@test "Looking up ${NET_IP}.6 should return the correct host" {
result="$(host ${NET_IP}.6 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "6.${REVERSE_ZONE} domain name pointer carbon.chem.net." ]
}

@test "Looking up ${NET_IP}.7 should return the correct host" {
result="$(host ${NET_IP}.7 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "7.${REVERSE_ZONE} domain name pointer nitrogen.chem.net." ]
}

@test "Looking up ${NET_IP}.8 should return the correct host" {
result="$(host ${NET_IP}.8 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "8.${REVERSE_ZONE} domain name pointer oxygen.chem.net." ]
}

@test "Looking up ${NET_IP}.9 should return the correct host" {
result="$(host ${NET_IP}.9 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "9.${REVERSE_ZONE} domain name pointer fluorine.chem.net." ]
}

@test "Looking up ${NET_IP}.10 should return the correct host" {
result="$(host ${NET_IP}.10 ${IP} | grep pointer)"
[ "$?" -eq 0 ]     # exit status should be 0
[ "${result}" = "10.${REVERSE_ZONE} domain name pointer neon.chem.net." ]
}

