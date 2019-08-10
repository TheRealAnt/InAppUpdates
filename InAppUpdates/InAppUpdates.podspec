Pod::Spec.new do |s|

s.name             = 'InAppUpdates'
s.version          = '0.1.0'
s.summary          = 'Checks for updated App version on the App Store.'
s.swift_version    = '4.0'
s.description      = "Provides an in app update dialog which notifies the user that there is a newer version of the app on the App Store."
s.homepage         = 'https://github.com/TheRealAnt/InAppUpdates'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Antonie Sander' => 'antonies9@hotmail.com' }
s.source           = { :git => 'https://github.com/TheRealAnt/InAppUpdates.git', :tag => s.version.to_s }
s.ios.deployment_target = '11.0'
s.source_files     = 'InAppUpdates/**/*'

end
