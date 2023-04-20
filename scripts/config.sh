#!/bin/bash

# This script configures the default search paths for many of the binaries
# and configuration files used by the project. Other scripts may source this
# file to find the resources that they need.

LGREEN='\033[1;32m'
LRED='\033[1;31m'
NC='\033[0m'

# Root directory.
BBB_KBUILD_PROJECT_PATH=$(dirname $(pwd))

# Binary directory.
BBB_KBUILD_BIN_DIR="${BBB_KBUILD_PROJECT_PATH}/bin"

# Kernel config docker context path.
BBB_KBUILD_DOCKER_PATH="${BBB_KBUILD_PROJECT_PATH}/docker"

# Linux kernel build files.
BBB_KBUILD_KERNEL_OBJ_PATH="${BBB_KBUILD_BIN_DIR}/obj"

# Linux kernel source tree directory.
BBB_KBUILD_KERNEL_SRC_PATH="${BBB_KBUILD_PROJECT_PATH}/linux"

# ccache path. Allows for the use of a build cache between kernel builds.
BBB_KBUILD_CCACHE_PATH="${BBB_KBUILD_BIN_DIR}/ccache"
