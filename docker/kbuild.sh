#!/bin/bash

ConfigKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
            O=$KERNEL_OBJ_DIR bb.org_defconfig
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
            O=$KERNEL_OBJ_DIR nconfig
    popd
}

BuildKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
            LOADADDR=0x80000000 O=$KERNEL_OBJ_DIR -j$(nproc) uImage dtbs
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
            O=$KERNEL_OBJ_DIR -j$(nproc) modules
    popd
}

InstallKernel()
{
    pushd $KERNEL_OBJ_DIR
        cp ./arch/arm/boot/zImage $ROOTFS_MOUNT/boot/vmlinuz-$KERNEL_VERSION

        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
            INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=$ROOTFS_MOUNT -j$(nproc) \
            modules_install
    popd
}

Main()
{
    ConfigKernel
    BuildKernel
    InstallKernel
}

Main
