# Change Log
All notable changes to this project will be documented in this file.
`Navigine.framework` adheres to [Semantic Versioning](http://semver.org/).

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
