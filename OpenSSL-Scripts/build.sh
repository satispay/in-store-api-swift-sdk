#!/bin/sh

if [ -f lib/libssl.a ] && [ -f lib/libcrypto.a ] && [ -d "$1" ]; then
    exit 0
fi

OPTIONS="no-ssl2 no-ssl3 no-comp no-async no-psk no-srp no-dtls no-dtls1"
OPTIONS+=" no-ec no-ec2m no-engine no-hw no-err"
OPTIONS+=" no-bf no-blake2 no-camellia no-cast no-chacha no-cmac no-ecdh no-ecdsa no-idea no-md4 no-mdc2 no-ocb no-poly1305 no-rc2 no-rc4 no-rmd160 no-scrpyt no-seed no-siphash no-sm3 no-sm4 no-whirlpool"
OPTIONS+=" -Wno-error=ignored-optimization-argument"

export CONFIG_OPTIONS="$OPTIONS"

./build-libssl.sh --archs="x86_64 i386 arm64 armv7" --version="1.0.2m"

mkdir -p "$1"
cp -R include/openssl "$1/"
