#
# Be sure to run `pod lib lint XHCommons.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHCommons'
  s.version          = '0.0.1'
  s.summary          = '0.0.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
commons_0.0.1
                       DESC

  s.homepage         = 'https://github.com/Lxh93/XHCommons'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lxh93' => 'xhlee1206@gmail.com' }
  s.source           = { :git => 'https://github.com/Lxh93/XHCommons.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'XHCommons/Classes/**/*'
  
  
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'XHCommonTools' => ['XHCommonTools/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'SnapKit'
  s.dependency 'PKHUD'
  s.dependency 'Moya'
  s.dependency 'HandyJSON'
  s.dependency 'SwiftyJSON'
  s.dependency 'Kingfisher'
  s.dependency 'FSPagerView'
  s.dependency 'Toast-Swift'
  s.dependency 'JKSwiftExtension'
end
