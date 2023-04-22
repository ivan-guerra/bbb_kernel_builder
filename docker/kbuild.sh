#!/bin/bash

Main()
{
    REPO_URL="https://github.com/RobertCNelson/ti-linux-kernel-dev.git"
    git clone $REPO_URL

    pushd ti-linux-kernel-dev
        git checkout $KERNEL_VERSION &&\
        ./build_deb.sh &&\
        cp deploy/*.deb $BIN_DIR
    popd
}

Main
