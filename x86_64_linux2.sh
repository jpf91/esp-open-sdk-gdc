#!/bin/bash

mkdir -p /home/build/nfs/download
mkdir -p /home/build/esp-open-sdk/crosstool-NG/.build/
ln -s /home/build/nfs/download /home/build/esp-open-sdk/crosstool-NG/.build/tarballs
ln -s ${PWD}/gdc /home/build/GDC

pushd /home/build/esp-open-sdk
    make
popd
