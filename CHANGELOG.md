# Change Log
All notable changes to this project will be documented in this file.
`Navigine.framework` adheres to [Semantic Versioning](http://semver.org/).

## [1.0.59](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.59) / 2019-08-09
* Small bugfixes and improvements

## [1.0.58](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.58) / 2019-07-23
* Navigation algorithms updated to version 2.0
* Fix issue with `NCSublocation`'s coordinate
* Small bugfixes and improvements

## [1.0.57](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.57) / 2019-06-10
* Add new protocol to NavigineCore:
```Objective-C
@protocol NavigineCoreBluetoothDelegate <NSObject>

- (void)navigineCore: (NavigineCore *)navigineCore didUpdateBluetoothState:(CBManagerState)status;

@end
```
You can use it for tracking bluetooth status.
***
* Small bugfixes in example projects
* Small bugfixes and improvements

## [1.0.56](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.56) / 2019-05-24
* Add new protocol to NavigineCore:
```Objective-C
@protocol NavigineCoreLocationDelegate <NSObject>

@optional

- (void)navigineCore: (NavigineCore *)navigineCore didUpdateLocations:(NSArray<CLLocation *> *)locations;

- (void)navigineCore: (NavigineCore *)navigineCore didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)navigineCore: (NavigineCore *)navigineCore didFailWithError:(NSError *)error;

@end
```
You can use it for tracking location updates and AuthorizationStatus
***
* Add new property ```lastKnownLocation``` to NavigineCore:
```Objective-C
@property (nonatomic, strong, nullable, readonly) NCGlobalPoint *lastKnownLocation;
```
It means last global location coordinates received from ```CLLocationManager```.

## [1.0.55](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.55) / 2019-04-29
* Classes ```NCBeacon```, ```NCDeviceInfo```, ```NCVenue``` now inherits from class ```NCLocationPoint```
* Initializers methods removed from classes such as: ```NCCategory```, ```NCLocation```, ```NCRouteEvent```, ```NCRoutePath```
* Changes in ```NCDeviceInfo``` class:
***
```Objective-C
@property (nonatomic, assign, readonly) float x;
@property (nonatomic, assign, readonly) float y;
```
now removed! Use
```Objective-C
@property (nonatomic, readonly) NSNumber *x;
@property (nonatomic, readonly) NSNumber *y;
```
from base-class ```NCLocationPoint```! Please change your code according to these changes. 
Otherwise your application will not build or will not working correctly.
***
```Objective-C
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;
```
now deprecated. Use
```Objective-C
@property (nonatomic, readonly, nullable) NCGlobalPoint *coordinates instead!
```
***
```Objective-C
@property (nonatomic, readonly, nullable) NCLocationPoint *locationPoint;
```
now deprecated. You can build it itself if you needed.
***

* Changes in ```NCSublocation``` class:
```Objective-C
@property (nonatomic, readonly) NSData *pngImage;
@property (nonatomic, readonly) NSData *jpgImage;
@property (nonatomic, readonly) NSData *svgImage;
@property (nonatomic, copy, readonly) NSString *svgFile;
@property (nonatomic, copy, readonly) NSString *pngFile;
@property (nonatomic, copy, readonly) NSString *jpgFile;
@property (nonatomic, strong, readonly, nullable) UIImage *image;
```
now deprecated. Consider new ```NCSublocationImage``` class.
***
```Objective-C
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;
```
now deprecated. Use ```@property (nonatomic, assign, readonly) CGSize dimensions;``` instead.
***
```Objective-C
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
```
now deprecated. Use ```@property (nonatomic, readonly, nullable) NCGlobalPoint *coordinates;``` instead.
***

* Fix issue in method
```Objective-C
- (void) downloadLocationById :(NSInteger)locationId
                  forceReload :(BOOL) forced
                 processBlock :(void(^)(NSInteger loadProcess))processBlock
                 successBlock :(void(^)(NSDictionary *userInfo))successBlock
                    failBlock :(void(^)(NSError *error))failBlock;
```
with ```forced``` flag.

* Added new class ```NCSublocationImage```
* Navigation algorithms updated to version 1.17
* Small bugfixes in example projects
* Improved algorithm of detection enter/exit zone

## [1.0.54](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.54) / 2019-03-27
* ```userHash```, ```server```, ```location``` in ```NavigineCore``` class now readonly properties
```Objective-C
@property (nonatomic, copy, readonly) NSString *server;
@property (nonatomic, copy, readonly) NSString *userHash;
@property (nonatomic, strong, readonly) NCLocation *location;
```
* Add description to navigation methods in ```NavigineCore``` class such as:
```Objective-C
- (NCRoutePath *) makeRouteFrom: (NCLocationPoint *)startPoint
                             to: (NCLocationPoint *)endPoint;
- (void) setTarget:(NCLocationPoint *)target;
- (void) cancelTarget;
- (void) cancelTargets;
- (void) setGraphTag:(NSString *)tag;
- (nullable NSString *)getGraphTag;
- (nullable NSString *)getGraphDescription:(NSString *)tag;
- (nullable NSArray *)getGraphTags;
- (void) addTarget:(NCLocationPoint *)target;
```
* ```startPushManager``` method in ```NavigineCore``` deprecated;
```Objective-C
- (void) startPushManager DEPRECATED_MSG_ATTRIBUTE("Method is not yet implemented. Don't use it!");
```

* Add validation for ```server``` and ```userHash``` in ```NavigineCore```. At now, if you enter invalid 
or corrupted ```server``` or ```userHash``` while initialising ```NavigineCore```, ```NavigineCore```
will not be created and will return ```nil```.

* Methods
```Objective-C
- (int)startLocationLoaderByUserHash: (NSString *)userHash
                          locationId: (NSInteger)locationId
                              forced: (BOOL) forced;
```
and
```Objective-C
- (int)startLocationLoaderByUserHash: (NSString *)userHash
                        locationName: (NSString *)location
                              forced: (BOOL) forced;
```
now deprecated. Use 
```Objective-C
- (NSInteger)startLocationLoaderByLocationId: (NSInteger)locationId;
```
or
```Objective-C
- (NSInteger)startLocationLoaderByLocationName: (NSString *)locationName;
```
instead.
* Fixed a bug leading to initialising ```CLLlocationManager``` in non main-thread
* Fix issue with main-thread checker in ```NavigineCoreNavigationDelegate``` protocol
* Small bugfixes and improvements

## [1.0.53](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.53) / 2019-03-01
* Navigation algorithms updated to version 1.14

## [1.0.52](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.52) / 2019-02-04
* Navigation algorithms updated to version 1.13
* Some bugfixes and improvements 

## [1.0.51](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.51) / 2018-12-28
* Navigation algorithms updated to version 1.11

## [1.0.50](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.50) / 2018-12-07
* Navigation algorithms updated to version 1.10

## [1.0.49](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.49) / 2018-11-22
* Navigation algorithms updated to version 1.9
* Fixed bug causing to "CLIENT is NULL" error when downloading location. 
* Added comparison methods to NCBeacon, NCVenue, NCZone. For example:
```Objective-C
/**
 Method for comparing beacons.

 @param otherBeacon Compared beacon
 @return YES if equals, NO othetwise
 */
- (BOOL) isEqualToBeacon: (NCBeacon *)otherBeacon;
```
* Initialization methods for NCLocation, NCRoutePath, NCRouteEvent, NCCategory now deprecated! In the next SDK Release we will remove them from public API.
```Objective-C
+ (instancetype) locationWithIdentifier: (NSInteger) identifier
                                   name: (NSString *) name
                       localDescription: (NSString *) description
                                version: (NSInteger) version
                           sublocations: (NSArray *) sublocations DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (instancetype) initWithIdentifier: (NSInteger) aIdentifier
                               name: (NSString *) aName
                   localDescription: (NSString *) aDescription
                            version: (NSInteger) aVersion
                       sublocations: (NSArray *) aSublocations DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");
```

```Objective-C
+ (instancetype) categoryWithIdentifier: (NSInteger)aIdentifier
                                   name: (NSString *)aName DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (instancetype) initWithIdentifier: (NSInteger)identifier
                               name: (NSString *)name NS_DESIGNATED_INITIALIZER DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");
```

```Objective-C
+ (instancetype) routePathWithLength: (float) length
                         routePoints: (NSArray *) points
                         routeEvents: (NSArray *) events DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (instancetype) initWithLength: (float) length
                    routePoints: (NSArray *) points
                    routeEvents: (NSArray *) events NS_DESIGNATED_INITIALIZER DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");
```

```Objective-C
+ (instancetype) routeEventWithDistance: (float) distance
                                  value: (int) value
                                   type: (NCRouteEventType) eventType DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (instancetype) initWithDistance: (float) distance
                            value: (int) value
                             type: (NCRouteEventType) eventType NS_DESIGNATED_INITIALIZER DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

```
* From the public header [NavigineSDK.h](https://github.com/Navigine/navigine_ios_framework/blob/master/Navigine%20Framework/Navigine.framework/Headers/NavigineSDK.h)
we removed all external dependencies!!!
#### Removed
```Objective-C
#import "NCDeviceInfo.h"
#import "NCRoutePath.h"
#import "NCLocation.h"
#import "NCLocationPoint.h"
#import "NCSublocation.h"
#import "NCVenue.h"
#import "NCZone.h"
#import "NCBeacon.h"
#import "NCRoutePath.h"
#import "NCRouteEvent.h"
```
If you don't want to import each class separately, you can import only [Navigine.h](https://github.com/Navigine/navigine_ios_framework/blob/master/Navigine%20Framework/Navigine.framework/Headers/Navigine.h)
* Various internal improvements

## [1.0.48](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.48) / 2018-10-12
* Fixed makeRoute function
* Fix bug with pushes

## [1.0.47](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.47) / 2018-10-10
* All property in public classes now readonly
* Navigation algorithms are improved
* Various internal improvements

## [1.0.46](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.46) / 2018-09-11
#### Fixed
* Backward compatibility returned

## [1.0.45](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.45) / 2018-09-10
#### Fixed
* Route issue fixed

## [1.0.44](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.44) / 2018-09-07

#### Renamed
In all public classes property "id" renamed to "identifier". For example:
```Objective-C
@property (nonatomic, assign) NSInteger id;
```
to:
```Objective-C
@property (nonatomic, readonly) NSInteger identifier;
```

In classes such as NCZone, NCVenue, NCSublocation, NCDeviceInfo, NCBeacon properties "sublocation" and "location" renamed to "sublocationId" and "locationId" respectively.
```Objective-C
@property (nonatomic) NSInteger location;
@property (nonatomic) NSInteger sublocation;
```
to:
```Objective-C
@property (nonatomic) NSInteger locationId;
@property (nonatomic) NSInteger sublocationId;
```

In class NCLocation method subLocationWithId renamed to sublocationWithId:

```Objective-C
- (NCSublocation *_Nullable) subLocationWithId: (NSInteger) subLocationId;
```
to:
```Objective-C
- (NCSublocation *_Nullable) sublocationWithId: (NSInteger) sublocationId;
```

#### Modified
Classes NCCategory, NCVenue, NCDeviceInfo, NCLocation, NCSublocation are no longer mutable. For example:
```Objective-C
@property (nonatomic, assign) NSInteger id;
```
to:
```Objective-C
@property (nonatomic, readonly) NSInteger identifier;
```
#### Modified
Method of NavigineCore class
```Objective-C
- (void) setTarget:(NCLocationPoint *)target;
```
Now works as cancelTarget + addTarget.

Method of NCLocation class 
```Objective-C
-(id) initWithLocation :(NCLocation *)location; 
```
is now deprecated.

You can use instead:
```Objective-C
+ (instancetype) locationWithIdentifier: (NSInteger) identifier
                                   name: (NSString *) name
                       localDescription: (NSString *) description
                                version: (NSInteger) version
                           sublocations: (NSArray *) sublocations;
```
or 
```Objective-C
- (instancetype) initWithIdentifier: (NSInteger) aIdentifier
                               name: (NSString *) aName
                   localDescription: (NSString *) aDescription
                            version: (NSInteger) aVersion
                       sublocations: (NSArray *) aSublocations;
```

## [0.9.4](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.43) / 2018-07-25

Fix bug with invalid url for downloading location

## [0.9.3](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.39) / 2018-05-11

#### Added
```Objective-C
- (void) cancelLocation;
```
method of NavigineCore class

#### Renamed
```Objective-C
- (void) loadArchiveById:(NSInteger)locationId
                    error:(NSError * _Nullable __autoreleasing *)error;

- (void) loadArchiveByName:(NSString *)location
                      error:(NSError * _Nullable __autoreleasing *)error;
```
to
```Objective-C
- (void) loadLocationById:(NSInteger)locationId
                    error:(NSError * _Nullable __autoreleasing *)error;

- (void) loadLocationByName:(NSString *)location
                      error:(NSError * _Nullable __autoreleasing *)error;
```

#### Fixed
* Bug in location parser
* Memmory leak in network utils

## [0.9.2](https://github.com/Navigine/navigine_ios_framework/releases/tag/v.1.0.37) / 2018-04-25

#### Added

```Objective-C
- (void) navigineCore:(NavigineCore *)navigineCore didUpdateDeviceInfo:(NCDeviceInfo *)deviceInfo;
- (void) navigineCore:(NavigineCore *)navigineCore didEnterZone:(NCZone *)zone;
- (void) navigineCore:(NavigineCore *)navigineCore didExitZone:(NCZone *)zone;
```
methods of NavigineCoreNavigationDelegate
* `NCBluetoothStateManager` class
* `NCGlobalPoint *lastKnownLocation` property of NCBluetoothStateManager class

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

```Objective-C
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
* Move 
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
