Pod::Spec.new do |s|
  s.name         = "CustomerlySDK"
  s.version      = "3.0.1"
  s.summary      = "customerly.io is the perfect tool to getting closer to your customers"
  s.description  = <<-DESC
  					customerly.io is the perfect tool to getting closer to your customers. Help them where they are with the customer support widget. Manage your audience based on their behaviours, build campaigns and automations.
					Deliver Surveys directly into your app and get the responses in one place. Study your Net Promote Score and Skyrocket your Online Business right now.
					The Customerly iOS SDK is really simple to integrate in your apps, and allow your users to contact you via chat.
                   DESC
  s.homepage     = "https://github.com/customerly/Customerly-iOS-SDK"
  s.screenshots  = "https://raw.githubusercontent.com/customerly/customerly.github.io/master/ios/resources/chat-preview.png"
  s.license      = { :type => "Apache License 2.0", :file => "LICENSE" }
  s.author             = { "Paolo Musolino" => "info@codeido.com" }
  s.social_media_url   = "https://www.facebook.com/customerly/"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/customerly/Customerly-iOS-SDK.git", :tag => s.version }
  s.source_files  = "CustomerlySDK/Library/**/*.swift"
  s.resource_bundles = {
    'CustomerlySDK' => ['CustomerlySDK/Library/**/*.xcassets', 'CustomerlySDK/Library/**/*.lproj', 'CustomerlySDK/Library/UI/**/*.storyboard', 'CustomerlySDK/Library/UI/**/*.xib', 'CustomerlySDK/Library/**/*.m4r']
  }
  s.module_name  = 'CustomerlySDK'
  s.frameworks  = "UIKit", "Foundation", "AudioToolbox"
  s.requires_arc = true
  s.dependency 'ObjectMapper', '3.5.1'
  s.dependency 'Kingfisher', '5.7.0'
  s.dependency 'Socket.IO-Client-Swift', '15.1.0'
  s.swift_versions = ['4.2', '5.0']
end