#!/bin/bash
set -ex

mkdir -p /home/build/nfs
mount /home/build/nfs
touch toolchain/id
chown -R build:build ${PWD}/gdc

su build -c ./x86_64_linux2.sh

pushd /home/build/esp-open-sdk
    rm -rf /home/build/nfs/xtensa-lx106-elf
    cp --no-preserve=ownership -R /home/build/esp-open-sdk/xtensa-lx106-elf/ /home/build/nfs/xtensa-lx106-elf/
popd

date > toolchain/id
