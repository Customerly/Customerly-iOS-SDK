</p>
<p align="center">
<img src="https://www.cdn.customerly.io/assets/img/Logo_Customerly_Name_Colored.svg">
</p>

 
  [![Language](https://img.shields.io/badge/Swift-3-orange.svg)]()
  
**customerly.io** is the perfect tool to getting closer to your customers. Help them where they are with the customer support widget. Manage your audience based on their behaviours, build campaigns and automations.

Deliver Surveys directly into your app and get the responses in one place. Study your Net Promote Score and Skyrocket your Online Business right now.

The Customerly iOS SDK is really simple to integrate in your apps, and allow your users to contact you via chat.

## Features
----------------

- [x] Register your users
- [x] Set attributes
- [x] Track events
- [x] Support via chat in real time
- [x] Surveys
- [x] English & Italian localizations
- [x] Many more is coming....

## Requirements
----------------

- iOS 8.0+
- Xcode 8+
- Swift 3
- The Objective-C compatibility is coming soon

## CocoaPods
----------------

To use the Customerly SDK we recommend to use Cocoapods 1.0.0 or later

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate the Customerly SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:


```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'CustomerlySDK', :git => 'GITURL'
```

Then, run the following command:

```bash
$ pod install
```

## Manually
----------------
1. Download and drop ```/Library``` folder in your project.  
2. Congratulations!  

We recommend to use only the open methods of the class Customerly.

## Usage
----------------
If you are setting up a new project, you need to install the SDK. You may have already completed this as part of creating a Customerly account. We recommend using CocoaPods 1.0.0 or later to install the SDK.

First of all, if you don't have an Xcode project yet, create one now, then install the SDK following the paragraph `Cocoapods`.

1) Import the Customerly iOS SDK module in your UIApplicationDelegate subclass:

```
import CustomerlySDK
```
2) Configure a Customerly iOS SDK shared instance, typically in your application's *application:didFinishLaunchingWithOptions:* method:

```
Customerly.sharedInstance.configure(secretKey: "YOUR_CUSTOMERLY_SECRET_KEY")
```

3) From iOS 10, you'll need to make sure that you add `NSPhotoLibraryUsageDescription` & `NSCameraUsageDescription` to your Info.plist so that your users have the ability to upload photos in Customerly's chat. Furthermore remember to set the `NSAppTransportSecurity` to `NSAllowsArbitraryLoads`.



### User registration



## Contributing

- If you **need help** or you'd like to **ask a general question**, open an issue or contact our support on [Customerly.io](https://www.customerly.io)
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Acknowledgements

Made with ❤️ by [Paolo Musolino](https://github.com/Codeido) for Customerly.


## License
----------------
Customerly iOS SDK is available under the XXX license. See the LICENSE file for more info.
