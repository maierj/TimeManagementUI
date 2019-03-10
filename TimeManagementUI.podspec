Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "TimeManagementUI"
s.summary = "TimeManagementUI provides UI components for displaying and letting users input date or time selections."
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Jonas Maier" => "maierjonas@live.de" }

s.homepage = "https://github.com/maierj/TimeManagementUI"

s.source = { :git => "https://github.com/maierj/TimeManagementUI.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"
s.dependency 'Alamofire', '~> 4.7'
s.dependency 'MBProgressHUD', '~> 1.1.0'

s.source_files = "TimeManagementUI/Source/*.{swift}"

s.swift_version = "4.2"

end
