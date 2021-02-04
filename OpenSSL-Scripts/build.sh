#!/bin/sh

if [ -d Frameworks/OpenSSL.xcframework ] && [ -d "$1" ]; then
    exit 0
fi

./build.sh

mkdir -p "$1"
cp -R Frameworks/OpenSSL.xcframework "$1/"
