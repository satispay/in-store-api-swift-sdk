Pod::Spec.new do |s|
  s.name             = 'SatispayInStore'
  s.version          = '0.1.0'
  s.summary          = 'Satispay inStore API framework'
  s.description      = <<-DESC
    You can use our API to access Satispay API endpoints, which can get information on received payments, pending ones and manage proposal of payments, besides many other operations.
                       DESC

  s.homepage         = 'https://github.com/satispay/in-store-api-swift-sdk'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Pierluigi D\'Andrea' => 'pierluigi.dandrea@satispay.com' }
  s.source           = { :git => 'https://github.com/satispay/in-store-api-swift-sdk.git', :tag => s.version.to_s, :submodules => true }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SatispayInStore/**/*.swift'
  s.preserve_paths = 'SatispayInStore/Modules/**/*', 'OpenSSL/lib/*.a'
  s.libraries  = 'crypto', 'ssl'
  s.vendored_libraries = 'OpenSSL/lib/libcrypto.a', 'OpenSSL/lib/libssl.a'

  s.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => File.join(File.dirname(__FILE__), 'SatispayInStore/Modules/iOS/**'),
      'LIBRARY_SEARCH_PATHS' => File.join(File.dirname(__FILE__), 'OpenSSL/lib'),
      'SWIFT_VERSION' => '4.0'
  }

  s.prepare_command = <<-CMD
      BASE_PATH="${PWD}"
      OPENSSL_PATH="$BASE_PATH/OpenSSL"
      MODULE_PATH="$BASE_PATH/SatispayInStore/Modules/iOS/OpenSSL"

      cd "$OPENSSL_PATH"

      if [ -f lib/libssl.a ] && [ -f lib/libcrypto.a ] && [ -d "$MODULE_PATH/openssl" ]; then
          exit 0
      fi

      OPTIONS="no-ssl2 no-ssl3 no-comp no-async no-psk no-srp no-dtls no-dtls1"
      OPTIONS+=" no-ec no-ec2m no-engine no-hw no-err"
      OPTIONS+=" no-bf no-blake2 no-camellia no-cast no-chacha no-cmac no-ecdh no-ecdsa no-idea no-md4 no-mdc2 no-ocb no-poly1305 no-rc2 no-rc4 no-rmd160 no-scrpyt no-seed no-siphash no-sm3 no-sm4 no-whirlpool"
      OPTIONS+=" -Wno-error=ignored-optimization-argument"

      export CONFIG_OPTIONS="$OPTIONS"

      ./build-libssl.sh --archs="x86_64 i386 arm64 armv7" --version="1.0.2m"

      mkdir -p $MODULE_PATH
      cp -R "$OPENSSL_PATH/include/openssl" "$MODULE_PATH/"
  CMD
end
