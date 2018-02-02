#!/bin/sh

if [ -f lib-ios/libssl.a ] && [ -f lib-ios/libcrypto.a ] && [ -f lib-macos/libssl.a ] && [ -f lib-macos/libcrypto.a ] && [ -d "$1" ] && [ -d "$2" ]; then
    exit 0
fi

./build.sh

mkdir -p "$1"
mkdir -p "$2"
cp -R include-ios/openssl "$1/"
cp -R include-macos/openssl "$2/"
