#!/bin/bash

# Source global project configurations.
source config.sh

KERNEL_VERSION="5.10.162-ti-rt-r59"

GetKernelVersion()
{
    read -p "Use default kernel version '$KERNEL_VERSION'? [y/n] " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]
    then
        read -p "What kernel version are you building: " -r
        KERNEL_VERSION=$REPLY
    fi
}

RunBuildContainer()
{
    pushd $BBB_KBUILD_DOCKER_PATH
        docker build -t bbb-kbuild:latest .

        BUILDER_NAME="bbb-kbuild"
        docker run -it --name $BUILDER_NAME \
            --privileged \
            -e KERNEL_VERSION=$KERNEL_VERSION \
            -e BIN_DIR=/out \
            -v $BBB_KBUILD_BIN_DIR:/out:rw \
            bbb-kbuild:latest

        docker rm -f $BUILDER_NAME
    popd
}

Main()
{
    mkdir -p $BBB_KBUILD_BIN_DIR
    GetKernelVersion
    RunBuildContainer
}

Main
