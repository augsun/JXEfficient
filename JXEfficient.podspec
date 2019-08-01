#
# Be sure to run `pod lib lint JXEfficient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXEfficient'
  s.version          = '0.5.11'
  s.summary          = 'A short description of JXEfficient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Efficient libraries for iOS development.
                       DESC

  s.homepage         = 'https://github.com/augsun'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CoderSun' => 'codersun@126.com' }
  s.source           = { :git => 'https://github.com/augsun/JXEfficient.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'JXEfficient/Classes/**/*.{h,m}'
  #s.resource_bundles = {
  #  'JXEfficient' => 'JXEfficient/Classes/**/*.{xib,pdf,png}'
  #}

  s.frameworks = 'UIKit', 'Foundation', 'Security', 'CoreLocation'

end
