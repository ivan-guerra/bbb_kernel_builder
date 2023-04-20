# Create a docker image that when run will build the Linux kernel and install
# it to a user specified rootfs. See scripts/build.sh for an example of how to
# launch a container instance of this image.

FROM debian:10.8-slim

RUN apt-get update     &&          \
    apt-get install -y             \
        bc                         \
        binutils-arm-linux-gnueabi \
        bison                      \
        build-essential            \
        ccache                     \
        cpio                       \
        curl                       \
        flex                       \
        gcc-arm-linux-gnueabihf    \
        kmod                       \
        libelf-dev                 \
        libncurses-dev             \
        libssl-dev                 \
        lzop                       \
        u-boot-tools

# Use ccache (make it appear in path earlier than /usr/bin/gcc, etc.).
RUN for p in gcc g++ cc c++; do ln -vs /usr/bin/ccache /usr/local/bin/$p; done

WORKDIR /setup
COPY kbuild.sh .

RUN chmod +x kbuild.sh
CMD ["/bin/bash", "-c", "./kbuild.sh"]
