## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like Navigine in your projects. See the ["Getting Started" guide for more information](https://https://github.com/Navigine/iOS-SDK/wiki/Getting-Started). You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Navigine 1.0.0+.

#### Podfile

To integrate Navigine into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'Navigine'
end
```

Then, run the following command:

```bash
$ pod install
```
