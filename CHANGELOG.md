# Change Log
All notable changes to this project will be documented in this file.
`Navigine.framework` adheres to [Semantic Versioning](http://semver.org/).

## [0.9.2](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.37) / 2018-04-25

#### Added
* 
```Objective-C
- (void) navigineCore:(NavigineCore *)navigineCore didUpdateDeviceInfo:(NCDeviceInfo *)deviceInfo;
- (void) navigineCore:(NavigineCore *)navigineCore didEnterZone:(NCZone *)zone;
- (void) navigineCore:(NavigineCore *)navigineCore didExitZone:(NCZone *)zone;
```
methods of NavigineCoreNavigationDelegate
* `NCBluetoothStateManager` class
* `NCGlobalPoint *lastKnownLocation` property of NCBluetoothStateManager class
* 
```Objective-C
typedef NS_ENUM(NSInteger, NCError) {
  NCLocationDoesNotExist = 1000,
  NCDownloadImpossible   = 1010,
  NCUploadImpossible     = 1020,
  NCURLRequestImpossible = 1030,
  NCInvalidArchive       = 1040,
  NCInvalidClient        = 1050,
  NCInvalidBeacon        = 1060
};
``` 
codes of NSErrors which using in NavigineCore 

* ```Objective-C
typedef NS_ENUM(NSInteger, NCNavigationError) {
  NCIncorrectClient    = 1,
  NCNoSolution         = 4,
  NCNoBeacons          = 8,
  NCIncorrectBMP       = 10,
  NCIncorrectGP        = 20,
  NCIncorrectXMLParams = 21
};
``` 
codes of NSErrors which using in NCDeviceInfo

#### Updated
* Remove 
```Objective-C
- (void) navigineCore:(NavigineCore *)navigineCore didEnterZone:(NCZone *)zone;
- (void) navigineCore:(NavigineCore *)navigineCore didExitZone:(NCZone *)zone;
```
from NavigineCoreDelegate to NavigineCoreNavigationDelegate

## [0.9.1](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.34) / 2018-04-12

#### Added
* `NCLocationPoint *locationPoint` and `NCGlobalPoint *globalPoint` properties of NCDeviceInfo class
* `NSArray *events` properties of NCRoutePath class

#### Updated
* Rename `addTatget` to `addTarget` method of NavigineCore class

#### Removed
* `float azimuth`, `float latitude`, `float longitude` properties of NCSublocation class
* `NSString *archiveFile` property of NCLocation and NCSublocation classes


## [0.9.0](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.26) / 2017-12-10

#### Added
* `isValid` function to all public SDK classes
* Static initializers of `NCLocationPoint` and `NCGlobalPoint`
* `Navigine.h` header file
* Center point of `NCZone`

#### Updated
* `NCLocationPoint` and `NCGlobalPoint` all properties are readonly

#### Removed
* `kX`  and `kY` properties from `NCBeacon`, `NCVenue` and `NCLocationPoint` classes
