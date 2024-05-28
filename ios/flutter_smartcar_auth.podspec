#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_smartcar.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_smartcar_auth'
  s.version          = '1.0.4'
  s.summary          = 'SmartcarAuth for Flutter which integrates the native iOS & Android SDKs.'
  s.description      = <<-DESC
  ''
                       DESC
  s.homepage         = 'https://smartcar.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Smartcar' => 'support@smartcar.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SmartcarAuth', '5.3.1'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
