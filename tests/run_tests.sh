#!/usr/bin/env bash
#
# Created:  Tue 15 Oct 2013 11:01:03 pm CEST
# Modified: Tue 15 Oct 2013 11:11:00 pm CEST CEST CEST
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
#

set -e # abort on nonzero exitstatus
set -u # abort on unbound variable

#--------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------

# Directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# BATS executable
BATS=${DIR}/bats/bin/bats

# Testscript for this host
SCRIPT="${DIR}/${HOSTNAME}.bats"

#--------------------------------------------------------------------------
# Script proper
#--------------------------------------------------------------------------

# If a test script for this host exists, run it, if not, exit with status 1
if [ -f "${SCRIPT}" ]; then
    echo Running test suite ${SCRIPT}
    sudo ${BATS} ${SCRIPT}
else
    echo "Test suite ${SCRIPT} not found, bailing out" >&2
    exit 1
fi

