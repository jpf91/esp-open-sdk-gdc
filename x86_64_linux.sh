#!/bin/bash
set -ex

mkdir -p /home/build/nfs
mount /home/build/nfs
mkdir -p /home/build/nfs/download
ln -s /home/build/nfs/download /home/build/esp-open-sdk/crosstool-NG/.build/tarballs
ln -s ${PWD}/gdc /home/build/GDC

pushd /home/build/esp-open-sdk
    make
    rm -rf /home/build/nfs/xtensa-lx106-elf
    cp --no-preserve=ownership -R /home/build/esp-open-sdk/xtensa-lx106-elf/ /home/build/nfs/xtensa-lx106-elf/
popd

date > toolchain/id
