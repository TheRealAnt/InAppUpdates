#
# Be sure to run `pod lib lint InAppUpdates.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InAppUpdates'
  s.version          = '0.1.0'
  s.summary          = 'Checks for updated App version on the App Store.'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Provides an in app update dialog which notifies the user that there is a newer version of the app on the App Store.
                       DESC

  s.homepage         = 'https://github.com/TheRealAnt/InAppUpdates'
  # s.screenshots    = '', ''
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Antonie Sander' => 'antonies9@hotmail.com' }
  s.source           = { :git => 'https://github.com/TheRealAnt/InAppUpdates.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/TheReaIAnt'

  s.ios.deployment_target = '10.0'

  s.source_files = 'InAppUpdates/Classes/**/*'
  
  # s.resource_bundles = {
  #   'InAppUpdates' => ['InAppUpdates/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Foundation', 'UIKit', 'SafariServices'
  # s.dependency
end
