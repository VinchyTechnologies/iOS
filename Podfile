platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'Nuke'
  pod 'FSPagerView'
  pod 'Google-Mobile-Ads-SDK'
  pod 'SwiftLint'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SPAlert', '~> 2.1.4' # has SPM
  pod "Sheeeeeeeeet" # has SPM
  pod 'Cosmos', '~> 23.0' # has SPM
  pod 'SkyFloatingLabelTextField' # has SPM
  pod 'FittedSheets' # has SPM
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
  pod 'SkyFloatingLabelTextField'
end

target 'VinchyAuthorizationApp' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
  pod 'Nuke'
  pod 'SkyFloatingLabelTextField'
  pod 'CocoaDebug', :configurations => ['Debug']
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
