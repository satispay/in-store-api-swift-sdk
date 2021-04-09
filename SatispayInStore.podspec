Pod::Spec.new do |s|
  s.name             = 'SatispayInStore'
  s.version          = '0.1.14'
  s.summary          = 'Satispay inStore API framework'
  s.description      = <<-DESC
    You can use our API to access Satispay API endpoints, which can get information on received payments, pending ones and manage proposal of payments, besides many other operations.
                       DESC

  s.homepage         = 'https://github.com/satispay/in-store-api-swift-sdk'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Davide Ceresola' => 'davide.ceresola@satispay.com' }
  s.source           = { :git => 'https://github.com/satispay/in-store-api-swift-sdk.git', :tag => s.version.to_s, :submodules => true }
  s.swift_versions   = "5.0"

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'SatispayInStore/**/*.swift'
  #s.dependency 'OpenSSL-Universal'

  s.vendored_frameworks = 'Frameworks/OpenSSL.xcframework'

  s.pod_target_xcconfig = {
      'SWIFT_VERSION' => '5.0'
  }

end
