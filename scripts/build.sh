#!/bin/bash

# This script launches a docker container that will build the Linux kernel and
# install it to a user specified rootfs. See the README for more details.

# Source global project configurations.
source config.sh

ROOTFS_MOUNT=""
KERNEL_VERSION="4.19.94-ti-r42"

GetKernelVersion()
{
    read -p "Use default kernel version '$KERNEL_VERSION'? [y/n] " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]
    then
        read -p "What BBB kernel version are you building: " -r
        KERNEL_VERSION=$REPLY
    fi
}

GetRootFSMountPoint()
{
    read -p "What is the path to your rootfs: " -r
    ROOTFS_MOUNT=$REPLY

    if [[ ! -d $ROOTFS_MOUNT ]]; then
        echo -e "${LRED}'$ROOTFS_MOUNT' does not exist!${NC}"
        exit 1
    fi

    read -p "Are you sure you want to write to '$ROOTFS_MOUNT'? [y/n] " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]
    then
        exit 0
    fi
}

RunBuildContainer()
{
    pushd $BBB_KBUILD_DOCKER_PATH
        docker build -t bbb-kernel-setup:latest .

        BUILDER_NAME="bbb-kernel-setup"
        docker run -it --name $BUILDER_NAME \
            --privileged \
            -e CCACHE_DIR=/ccache \
            -e KERNEL_SRC_DIR=$BBB_KBUILD_KERNEL_SRC_PATH \
            -e KERNEL_OBJ_DIR=$BBB_KBUILD_KERNEL_OBJ_PATH \
            -e KERNEL_VERSION=$KERNEL_VERSION \
            -e ROOTFS_MOUNT=$ROOTFS_MOUNT \
            -v $BBB_KBUILD_KERNEL_SRC_PATH:$BBB_KBUILD_KERNEL_SRC_PATH:rw \
            -v $BBB_KBUILD_KERNEL_OBJ_PATH:$BBB_KBUILD_KERNEL_OBJ_PATH:rw \
            -v $BBB_KBUILD_CCACHE_PATH:/ccache:rw \
            -v $ROOTFS_MOUNT:/mnt:rw \
            bbb-kernel-setup:latest

        docker rm -f $BUILDER_NAME
    popd
}

Main()
{
    # Create the kernel binary output directory if it does not already exist.
    # Caching the build objects on the host allows us to pass the obj dir
    # as a volume to the docker container. This is handy for speeding up
    # builds.
    mkdir -p $BBB_KBUILD_KERNEL_OBJ_PATH
    mkdir -p $BBB_KBUILD_CCACHE_PATH

    GetKernelVersion
    GetRootFSMountPoint
    RunBuildContainer
}

Main
