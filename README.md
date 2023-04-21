# BeagleBone Black Kernel Builder

This project provides a Docker image and supporting scripts for configuring,
building, and deploying a custom kernel to the [BeagleBone Black][1].

### Required Software

All scripts and containers within this project are meant to be run on a Linux
system. Below is a list of the required software.

- [ ] Git
- [ ] Bash
- [ ] Docker

### Prepping the SD Card

The scripts and container assume you have a SD card flashed with one of the
latest Debian images provided by [beagleboard.org][2]. I recommend the console
images due to their compactness though the IoT image will work just as well. The
commands below demonstrate how one would setup an SD card with a Debian Console
image.

Download the latest image from [beagleboard.org][2]:
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

Writing the image to the SD will take a few minutes. Once writing completes,
mount the SD partition and take note of the kernel version:
```bash
sudo mount /dev/sdb1 /mnt/sd
ls /mnt/sd/boot/vmlinuz*
```
The version number following `vmlinuz-` is the number you should note. In this
example, the kernel version is `4.19.94-ti-r42`.

### Checking Out the Kernel

To ease deployment, we will be building the kernel version identified in
[Prepping the SD Card](#prepping-the-sd-card). You will want to set the `linux`
submodule to point to the appropriate kernel version. For example, if the kernel
version is `4.19.94-ti-r42`, then you would run the following commands to get
the right branch:

```bash
cd linux
git checkout 4.19.94-ti-r42
```

At this point, you can make edits, apply patches, etc. to the Linux kernel
sources.

### Building and Deploying the Kernel to the SD Card

Mount the SD card to your host filesystem if you have not already. To configure,
build, and deploy the kernel run the [`build.sh`](scripts/build.sh) script and
follow the prompts:

```bash
cd scripts && ./build.sh
```

After the script completes, unmount the SD card and insert it into the BBB SD
slot. You are now ready to boot off the SD and enjoy your custom kernel!

[1]: https://beagleboard.org/black
[2]: https://beagleboard.org/latest-images
