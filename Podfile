platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'RealmSwift'
  pod 'InputBarAccessoryView'
  pod 'SDWebImage'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'JGProgressHUD'
end

def ads
  pod 'Google-Mobile-Ads-SDK'
end

def texture
  pod 'Texture', '~> 3.0.0'
end

target 'Smart' do
  project 'Smart'

  commonPods
  ads
  texture

  target 'SmartTests' do
    inherit! :search_paths
  end

  target 'SmartUITests' do
  end

end

target 'Display' do
  project 'submodules/Display/Display'
  texture
  pod 'SDWebImage'
end

target 'Database' do
  project 'submodules/Database/Database'
  pod 'RealmSwift'
end

target 'Core' do
  project 'submodules/Core/Core'
  pod 'RealmSwift'
end

target 'StringFormatting' do
  project 'submodules/StringFormatting/StringFormatting'
end

target 'CommonUI' do
  project 'submodules/CommonUI/CommonUI'
end

target 'LocationUI' do
  project 'submodules/LocationUI/LocationUI'
  texture
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

