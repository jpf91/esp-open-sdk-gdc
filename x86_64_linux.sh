#!/bin/bash
set -ex

mkdir -p /home/build/nfs
mount /home/build/nfs
touch toolchain/id
chown -R build:build ${PWD}/gdc
chown -R build:build toolchain/id
su build
mkdir -p /home/build/nfs/download
mkdir -p /home/build/esp-open-sdk/crosstool-NG/.build/
ln -s /home/build/nfs/download /home/build/esp-open-sdk/crosstool-NG/.build/tarballs
ln -s ${PWD}/gdc /home/build/GDC

pushd /home/build/esp-open-sdk
    make
    rm -rf /home/build/nfs/xtensa-lx106-elf
    cp --no-preserve=ownership -R /home/build/esp-open-sdk/xtensa-lx106-elf/ /home/build/nfs/xtensa-lx106-elf/
popd

date > toolchain/id
