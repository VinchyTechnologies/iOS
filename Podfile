platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'FSPagerView'
  pod 'Google-Mobile-Ads-SDK'
  pod 'SwiftLint'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SPAlert', '~> 2.1.4'
  pod "Sheeeeeeeeet"
  pod 'Cosmos', '~> 23.0'
  pod 'SkyFloatingLabelTextField'
  pod 'KeychainAccess'
  pod 'FittedSheets'
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
  pod 'SkyFloatingLabelTextField'
end

target 'Core' do
  project 'submodules/Core/Core'
  pod 'KeychainAccess'
end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
  pod 'Cosmos', '~> 23.0'
end

target 'VinchyAuthorizationApp' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
  pod 'SkyFloatingLabelTextField'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'KeychainAccess'
end

target 'VinchyAnalytics' do
  project 'submodules/VinchyAnalytics/VinchyAnalytics'
  pod 'Firebase/Analytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
