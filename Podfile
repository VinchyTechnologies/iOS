platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'FSPagerView' # no spm...
#  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SwiftLint'
  
  pod 'Google-Mobile-Ads-SDK'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics'
  pod 'Epoxy'
  pod 'SPAlert', '~> 2.1.4'
  pod 'FittedSheets'
  pod 'Sheeeeeeeeet'
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
  pod 'Epoxy'
  pod 'Google-Mobile-Ads-SDK'
end

target 'VinchyStore' do
  project 'submodules/VinchyStore/VinchyStore'
  pod 'Epoxy'
end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
  pod 'Epoxy'
end

target 'VinchyUI' do
  project 'submodules/VinchyUI/VinchyUI'
  pod 'Firebase/DynamicLinks'
end

target 'WineDetail' do
  project 'submodules/WineDetail/WineDetail'
  pod 'FSPagerView' # no spm...
  pod 'Epoxy'
  pod 'SPAlert', '~> 2.1.4'
  pod 'Sheeeeeeeeet'
  pod 'Firebase/DynamicLinks'
end

target 'VinchyAuthorization' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
  pod 'FittedSheets'
end

target 'VinchyAuthorizationApp' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'FittedSheets'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
