#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_smartcar.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_smartcar_auth'
  s.version          = '2.0.0'
  s.summary          = 'Flutter plugin for SmartcarAuth, enabling authentication and configuration like the native Smartcar library for iOS & Android.'
  s.description      = <<-DESC
  ''
                       DESC
  s.homepage         = 'https://smartcar.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Smartcar' => 'support@smartcar.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'Extensions/**/*'
  s.dependency 'Flutter'
  s.dependency 'SmartcarAuth', '6.0.2'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
