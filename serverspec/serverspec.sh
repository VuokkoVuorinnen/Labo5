#!/bin/bash

## who am i? ##
_script="$(readlink -f ${BASH_SOURCE[0]})"
## Delete last component from $_script ##
CURRENTDIR="$(dirname $_script)"

echo "Running tests for helium"
cd $CURRENTDIR/helium
rake spec

echo "Running tests for beryllium"
cd $CURRENTDIR/beryllium
rake spec

echo "Running tests for neon"
cd $CURRENTDIR/neon
rake spec

exit 0
