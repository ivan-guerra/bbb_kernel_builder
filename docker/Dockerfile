FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y \
        bc \
        bison \
        build-essential \
        cpio \
        curl \
        fakeroot \
        flex \
        gettext \
        git \
        kmod \
        libmpc-dev \
        libncurses5-dev \
        libssl-dev \
        lsb-release \
        lzma \
        lzop \
        man-db \
        pkg-config \
        rsync \
        u-boot-tools \
        wget

WORKDIR /build
COPY kbuild.sh .
RUN chmod +x kbuild.sh

CMD ["/bin/bash", "-c", "./kbuild.sh"]
