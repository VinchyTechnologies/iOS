platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'RealmSwift', '~> 10.0.0'
  pod 'Nuke'
  pod 'FSPagerView'
  pod 'Google-Mobile-Ads-SDK'
  pod 'SwiftLint'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/RemoteConfig'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SPAlert'
  pod "Sheeeeeeeeet"
end

target 'Smart' do
  project 'Smart'

  commonPods

  target 'SmartTests' do
    inherit! :search_paths
  end

  target 'SmartUITests' do
  end

end

target 'Display' do
  project 'submodules/Display/Display'
  pod 'Nuke'
end

target 'Database' do
  project 'submodules/Database/Database'
  pod 'RealmSwift', '~> 10.0.0'
end

target 'Core' do
  project 'submodules/Core/Core'
end

target 'StringFormatting' do
  project 'submodules/StringFormatting/StringFormatting'
end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
  pod 'Nuke'
end

target 'LocationUI' do
  project 'submodules/LocationUI/LocationUI'
end

target 'EmailService' do
  project 'submodules/EmailService/EmailService'
end

target 'VinchyCore' do
  project 'submodules/VinchyCore/VinchyCore'
end

target 'VinchyUI' do
  project 'submodules/VinchyUI/VinchyUI'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
