#!/bin/sh

if [ -f iphoneos/lib/libssl.a ] && [ -f iphoneos/lib/libcrypto.a ] && [ -f macos/lib/libssl.a ] && [ -f macos/lib/libcrypto.a ] && [ -d "$1" ] && [ -d "$2" ]; then
    exit 0
fi

./scripts/build.sh

mkdir -p "$1"
mkdir -p "$2"
cp -R iphoneos/include/openssl "$1/"
cp -R macos/include/openssl "$2/"
