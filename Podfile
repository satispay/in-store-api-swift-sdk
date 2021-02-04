# Uncomment the next line to define a global platform for your project
use_frameworks!

workspace 'SatispayInStore.xcworkspace'

def shared_pods
    project 'SatispayInStore.xcodeproj'
    pod 'OpenSSL-Universal'
end

target 'Example' do
  # Pods for Example
  platform :ios, '9.0'
  shared_pods

end

target 'SatispayInStore-iOS' do
  # Pods for SatispayInStore-iOS
  platform :ios, '9.0'
  shared_pods

end

target 'SatispayInStore-macOS' do
  # Pods for SatispayInStore-macOS
  platform :osx, '10.10'
  shared_pods

end
