#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint site24x7_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'site24x7_flutter_plugin'
    s.version          = '1.0.0'
    s.summary          = 'Site24x7 SDK for Flutter.'
    s.description      = <<-DESC
  Site24x7 SDK to monitor Flutter Mobile Applications
                         DESC
    s.homepage         = 'https://www.site24x7.com/mobile-apm.html'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Site24x7' => 'support@site24x7.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.dependency 'Flutter'
    s.dependency 'Site24x7APM'
    s.platform = :ios, '11.0'
  
    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.swift_version = '5.0'
  end
  