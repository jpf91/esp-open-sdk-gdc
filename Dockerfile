FROM buildpack-deps:jessie

# Set root password to root. Useful when debugging this container to install new packages
RUN echo "root:root" | chpasswd

# Install build requirements
RUN apt-get update && apt-get install -y \
	make \
	unrar-free \
	autoconf \
	automake \
	libtool \
	gcc \
	g++ \
	gperf \
	flex \
	bison \
	texinfo \
	gawk \
	ncurses-dev \
	libexpat-dev \
	python-dev \
	python \
	python-serial \
	sed \
	git \
	unzip \
	bash \
	help2man \
	wget \
	bzip2 \
	libtool-bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "nfs-cache.lan:/ /home/build/nfs nfs4 rw,noauto,user,exec,nosuid,nodev 0 0" >> /etc/fstab

# Add build user
RUN adduser --disabled-password --gecos "" build \
    && echo "build:build" | chpasswd \
    && chsh -s /bin/bash build \
    && echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Initialize /home/build directory
WORKDIR /home/build
USER build

ENV ESP_REV b1929e33f41c4bd9715e5f91ab0cf68de5939396

ADD crosstool-gdc.patch /home/build/

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git  \
    && cd esp-open-sdk \
    && git checkout ${ESP_REV} \
    && git submodule update \
    && patch -p0 -i ../crosstool-gdc.patch \
    && rm ../crosstool-gdc.patch \
    && echo 'CT_CC_LANG_OTHERS="d"' >> crosstool-config-overrides \
    && echo 'CT_CC_GCC_EXTRA_CONFIG_ARRAY="--disable-libphobos"' >> crosstool-config-overrides

ADD x86_64_linux.sh /home/build
