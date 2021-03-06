#
# Be sure to run `pod lib lint sdkTerebinto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sdkTerebinto'
  s.version          = '2.0.0'
  s.summary          = 'A short description of sdkTerebinto.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/andreterebinto/sdkTerebinto'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andre Terebinto' => 'andreterebinto@hotmail.com' }
  s.source           = { :git => 'https://github.com/andreterebinto/sdkTerebinto.git', :tag => s.version.to_s }
  
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'sdkTerebinto/Classes/**/*'
  
  # s.resource_bundles = {
  #   'sdkTerebinto' => ['sdkTerebinto/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire'
   s.dependency 'SwiftyJSON'
   s.dependency 'scryptTerebinto'
   s.dependency 'CryptoSwift', '~> 1.3.8'
   s.dependency 'CommonCryptoModule', '~> 1.0.1'
   s.dependency 'JWTDecode', '~> 2.6'
   
end
