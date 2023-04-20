#!/bin/bash

# This script cleans up the source tree leaving it as if a fresh clone of
# the repository was made.

# Source global project configurations.
source config.sh

# Remove the binary directory.
if [ -d $BBB_KBUILD_BIN_DIR ]
then
    echo -e "${LGREEN}Removing '$BBB_KBUILD_BIN_DIR'${NC}"
    rm -r $BBB_KBUILD_BIN_DIR
fi
