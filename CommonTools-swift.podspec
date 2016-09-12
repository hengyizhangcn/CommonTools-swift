#
# Be sure to run `pod lib lint CommonTools-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CommonTools-swift'
  s.version          = '0.1.0'
  s.summary          = 'common tools, like base request, base tableview etc.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
common tools, like base request, base tableview etc.
                       DESC

  s.homepage         = 'https://github.com/hengyizhangcn/CommonTools-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hengyizhangcn@gmail.com' => 'hengyizhangcn@gmail.com' }
  s.source           = { :git => 'https://github.com/hengyizhangcn/CommonTools-swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'CommonTools-swift/**/*'

  #s.subspec 'BaseRequest' do |ss|
  #  ss.source_files = 'CommonTools-swift/BaseRequest/*'
  #end

  #s.subspec 'BaseTableView' do |ss|
  #  ss.source_files = 'CommonTools-swift/BaseTableView/*'
  #end

  #s.subspec 'Categories' do |ss|
  #  ss.source_files = 'CommonTools-swift/Categories/*'
  #end

  # s.resource_bundles = {
  #   'CommonTools-swift' => ['CommonTools-swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.5.3'
  #s.dependency 'YAUIKit', '~> 3.0.0'
end
