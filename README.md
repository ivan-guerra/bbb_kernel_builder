# BeagleBone Black Kernel Builder

This project provides a Docker image and supporting scripts for configuring and
building a custom kernel for the [BeagleBone Black][1] dev board.
`bbb_kernel_builder` provides a container able to run the build scripts included
in the [`ti-linux-kernel-dev`][2] project. The container is a convenience in the
sense that it saves you from having to install the array of tools needed to
build the kernel with the added benefit of supporting Windows builds via
Docker Desktop. The output of the container is a set of `*.deb` files that make
up the kernel, headers, etc. Those `*.deb` files are ready to be transferred to
the BBB and can be installed using the `dpkg` utility.

The following sections will walk you through the process of setting up an SD
card with an official Debian BBB image. We'll then run the `bbb_kernel_builder`
scripts to configure and build the kernel. Finally, we'll show you how to
transfer and install the kernel to the BBB.

### Prepping the SD Card

To get started, flash a micro SD card with the latest BBB Debian image. I
recommend the console images due to their compactness though the IoT image will
work just as well.

Download the latest image from [beagleboard.org][3]:
```bash
wget https://debian.beagleboard.org/images/bone-debian-10.3-console-armhf-2020-04-06-1gb.img.xz
```

Unarchive the `*.img` file:
```bash
xz -d *.xz
```

Write `*.img` to your SD card. **In the command below we assume the SD card is
the device `/dev/sdb`. Make sure you enter the device name that corresponds to
your SD card!**
```bash
sudo dd if=*.img of=/dev/sdb
```
Writing the image to the SD will take a few minutes.

### Building and Configuring the Kernel

To kick off the build, change directory to the [`scripts`](scripts) directory
and run the [`build.sh`](scripts/build.sh) script:
```bash
./build.sh
```

The script will prompt you for a kernel version. If you navigate to the
[`ti-linux-kernel-dev`][4] repository, you can browse the tags to find a version
number that suites your needs. Note, the tags with `*-rt-*` are kernels with the
`PREEMPT_RT` patches applied.

After selecting a version, the script will checkout the kernel sources, apply
patches, etc. During the process, you will be prompted to configure the kernel
via `menuconfig`. Make your selections and then proceed with the build.
Depending on your machine, building the kernel and modules can take a while.

Output `*.deb` files will be installed to `bbb_kernel_builder/bin`.

### Deploying the Kernel to the BBB

To kick off kernel deployment, mount the SD card with the BBB rootfs:
```bash
sudo mount /dev/sdb1 /mnt/sd
```

Copy the `bbb_kernel_builder/bin/*.dev` files to the BBB:
```bash
sudo cp bbb_kernel_builder/bin/*.dev /mnt/sd/root
```

`umount` the SD card and boot the BBB from the SD. Log on to the BBB as `root`
and install your new kernel:
```bash
dpkg -i /root/*.deb
```

Reboot the BBB off the SD card. Run `uname -a` and verify the kernel version you
previously selected is the one displayed.

[1]: https://beagleboard.org/black
[2]: https://github.com/RobertCNelson/ti-linux-kernel-dev
[3]: https://beagleboard.org/latest-images
[4]: https://github.com/RobertCNelson/ti-linux-kernel-dev/tags
