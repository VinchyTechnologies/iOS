platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def epoxy
  pod 'EpoxyCore'
  pod 'EpoxyLayoutGroups'
  pod 'EpoxyCollectionView'
  pod 'EpoxyBars'
end

def commonPods
  pod 'FSPagerView' # no spm...
  pod 'SwiftLint'
  pod 'FittedSheets'
  epoxy
end

target 'Smart' do
  project 'Smart'
  pod 'GoogleUtilities'
  pod 'Firebase/DynamicLinks'
  pod 'Google-Mobile-Ads-SDK'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'Firebase/RemoteConfig'
  pod 'SPAlert', '~> 2.1.4'
  commonPods

  target 'SmartTests' do
    inherit! :search_paths
  end

  target 'SmartUITests' do
  end  
end

target 'VinchyAppClip' do
  use_modular_headers!
  commonPods
end

target 'Display' do
  project 'submodules/Display/Display'
  epoxy
end

target 'AdUI' do
  project 'submodules/AdUI/AdUI'
end

target 'VinchyStore' do
  project 'submodules/VinchyStore/VinchyStore'
  epoxy
end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
  epoxy
end

target 'VinchyUI' do
  project 'submodules/VinchyUI/VinchyUI'
  epoxy
end

target 'WineDetail' do
  project 'submodules/WineDetail/WineDetail'
  pod 'FSPagerView' # no spm...
  epoxy
end

target 'VinchyAuthorization' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
#  pod 'FittedSheets'
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
