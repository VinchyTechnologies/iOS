platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
#  pod 'Nuke'
  pod 'KeychainAccess'
  pod 'Cosmos', '~> 23.0'
  pod 'FSPagerView' # no spm...
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SwiftLint'
  
  pod 'Google-Mobile-Ads-SDK'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics'
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

#target 'Display' do
#  project 'submodules/Display/Display'
#  pod 'Nuke'
#end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
#  pod 'Nuke'
  pod 'Cosmos', '~> 23.0'
end

target 'Core' do
  project 'submodules/Core/Core'
  pod 'KeychainAccess'
end

target 'VinchyAuthorizationApp' do
  project 'submodules/VinchyAuthorization/VinchyAuthorization'
  pod 'CocoaDebug', :configurations => ['Debug']
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
