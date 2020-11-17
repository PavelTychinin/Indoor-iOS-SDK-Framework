Pod::Spec.new do |spec|
  spec.name                 = 'Navigine'
  spec.version              = '1.2.0'
  spec.license              = { :type => 'Custom', :text => 'Navigine Licence'}
  spec.summary              = "iOS SDK for performing indoor navigation"
  spec.platform             = :ios, "8.0"
  spec.homepage             = 'https://github.com/Navigine/navigine_ios_framework'
  spec.authors              = { 'Pavel Tychinin' => 'p.tychinin@navigine.com' , 'Il Kadyrov' => 'i.kadyrov@navigine.com'}
  spec.source               = { :git => 'https://github.com/Navigine/navigine_ios_framework.git', :tag => 'v.1.2.0' }
  spec.documentation_url    = 'https://github.com/Navigine/navigine_ios_framework/wiki/Getting-Started'
  spec.vendored_frameworks  = 'Navigine Framework/Navigine.framework'
#  spec.vendored_libraries   = 'Navigine Framework/Navigine.framework/Navigine'
  spec.public_header_files  = 'Navigine Framework/Navigine.framework/Headers/*.h'
  spec.source_files         = 'Navigine Framework/Navigine.framework/Headers'
  spec.pod_target_xcconfig  = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.exclude_files        = "Classes/Exclude"
  spec.requires_arc         =  true
end
