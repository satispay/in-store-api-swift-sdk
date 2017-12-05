# Satispay InStore client

This project provides an example iOS application using the Satispay InStore framework to interact with the Satispay in store API.

More information about the API can be retrived in their [documentation](https://s3-eu-west-1.amazonaws.com/docs.satispay.com/index.html#instore-api).

## Requirements

- iOS 8.0+
- Swift 3.2/4.0

## Example project usage

Clone the repo:

	git clone https://github.com/satispay/in-store-api-swift-sdk
	
From the repo root init submodules:

	git submodule update --init --recursive
	
Open `SatispayInStore.xcodeproj` and compile.

## Installation

### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "Satispay/in-store-api-swift-sdk"
```

### [Cocoapods](https://cocoapods.org)
Add the following lines to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```
pod 'SatispayInStore'
```

### Copying source files

SatispayInStore can also be used just by coping source files from the SatispayInStore framework target into your Xcode project.

## Usage
### Environment configuration
SatispayInStore supports the following environments:

- Production (*default*)
- Staging
- Test

To select a different environment, in your app delegate:

```
SatispayInStoreConfig.environment = StagingEnvironment()
```
