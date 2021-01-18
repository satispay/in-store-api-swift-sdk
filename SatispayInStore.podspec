Pod::Spec.new do |s|
  s.name             = 'SatispayInStore'
  s.version          = '0.1.14'
  s.summary          = 'Satispay inStore API framework'
  s.description      = <<-DESC
    You can use our API to access Satispay API endpoints, which can get information on received payments, pending ones and manage proposal of payments, besides many other operations.
                       DESC

  s.homepage         = 'https://github.com/satispay/in-store-api-swift-sdk'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Pierluigi D\'Andrea' => 'pierluigi.dandrea@satispay.com' }
  s.source           = { :git => 'https://github.com/satispay/in-store-api-swift-sdk.git', :tag => s.version.to_s, :submodules => true }
  s.swift_versions   = "5.0"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'SatispayInStore/**/*.swift'
  s.preserve_paths = 'SatispayInStore/Modules/**/*', 'OpenSSL/lib-ios/*.a', 'OpenSSL/lib-macos/*.a'
  s.libraries  = 'crypto', 'ssl'
  s.ios.vendored_libraries = 'OpenSSL/lib-ios/libcrypto.a', 'OpenSSL/lib-ios/libssl.a'
  s.osx.vendored_libraries = 'OpenSSL/lib-macos/libcrypto.a', 'OpenSSL/lib-macos/libssl.a'

  s.ios.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/SatispayInStore/SatispayInStore/Modules/iOS/**',
      'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/SatispayInStore/OpenSSL/lib-ios',
      'SWIFT_VERSION' => '5.0'
  }

  s.osx.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/SatispayInStore/SatispayInStore/Modules/macOS/**',
      'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/SatispayInStore/OpenSSL/lib-macos',
      'SWIFT_VERSION' => '5.0'
  }

  s.prepare_command = <<-CMD
      BASE_PATH="${PWD}"
      OPENSSL_PATH="$BASE_PATH/OpenSSL"
      MODULE_PATH_IOS="$BASE_PATH/SatispayInStore/Modules/iOS/OpenSSL"
      MODULE_PATH_MACOS="$BASE_PATH/SatispayInStore/Modules/macOS/OpenSSL"

      cd "$OPENSSL_PATH"

      if [ -f lib-ios/libssl.a ] && [ -f lib-ios/libcrypto.a ] && [ -f lib-macos/libssl.a ] && [ -f lib-macos/libcrypto.a ] && [ -d "$MODULE_PATH_IOS/openssl" ] && [ -d "$MODULE_PATH_MACOS/openssl" ]; then
          exit 0
      fi

      ./scripts/build.sh
      ./scripts/create-frameworks.sh

      mkdir -p $MODULE_PATH_IOS
      mkdir -p $MODULE_PATH_MACOS
      cp -R "$OPENSSL_PATH/iphoneos/include/openssl" "$MODULE_PATH_IOS/"
      cp -R "$OPENSSL_PATH/macos/include/openssl" "$MODULE_PATH_MACOS/"
  CMD
end
