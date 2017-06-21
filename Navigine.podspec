Pod::Spec.new do |spec|
  spec.name         		= 'Navigine'
  spec.version      		= '1.0.8'
  spec.platform     		= :ios, "8.0"
  spec.summary      		= "iOS SDK for performing indoor navigation"
  spec.authors      		= { 'Pavel Tychinin' => 'p.tychinin@navigine.com' }
  spec.homepage     		= 'https://navigine.com'
  spec.documentation_url  	= 'https://github.com/Navigine/iOS-SDK/wiki/Getting-Started'
  spec.license      	   	= { :type => 'Copyright', :text => "Copyright 2017 Navigine inc. All rights reserved."}
  spec.source       	   	= { :git => 'https://github.com/Navigine/navigine_ios_framework.git' , :tag => 'v1.0.8'}
  spec.vendored_frameworks 	= 'Navigine.framework'
  spec.requires_arc        	=  true
end