platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Smart'

def commonPods
  pod 'FSPagerView' # no spm...
#  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'SwiftLint'
  
  pod 'GoogleUtilities'
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
  
  target 'VinchyAppClip' do
    pod 'GoogleUtilities'
  end
end

target 'Display' do
  project 'submodules/Display/Display'
  pod 'Epoxy'
  pod 'GoogleUtilities'
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
  pod 'GoogleUtilities'
  pod 'Firebase/DynamicLinks'
end

target 'WineDetail' do
  project 'submodules/WineDetail/WineDetail'
  pod 'GoogleUtilities'
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
  
  #Добавляем путь до firebase (чтото ему плохеет когда импортим отдельно в модуль)
#     installer.aggregate_targets.each do |aggregate_target|
#       append_header_search_path(aggregate_target, "\"${PODS_ROOT}/Firebase/CoreOnly/Sources\"")
#     end
#
#     puts "Removing duplicate symbols"
#
#     #Удаляем дубликаты фреймвороков при линковке,
#     #Сначала указываем frameworks, где должны остаться импорты пересекающихся модулей
#     #Затем frameworks которые будем чистить от пересекающихся модулей
#
#     libraryTargets = [
#         'Pods-Display',
#         'Pods-VinchyUI'
#     ]
#
#     remove_duplicate_frameworks(installer, libraryTargets, 'Pods-Smart')
##     remove_duplicate_frameworks(installer, 'Pods-WineDetail', 'Pods-Display')
##     remove_duplicate_frameworks(installer, 'Pods-Delivery Club Analytics', 'Pods-Delivery Club Remote Config')
end

def remove_duplicate_frameworks(installer, library_targets, cleaning_targets)
  embedded_targets = installer.aggregate_targets.select { |aggregate_target|
    library_targets.include? aggregate_target.name
  }
  embedded_pod_targets = embedded_targets.flat_map { |embedded_target| embedded_target.pod_targets }
  host_targets = installer.aggregate_targets.select { |aggregate_target|
    cleaning_targets.include? aggregate_target.name
  }

  host_targets.each do |host_target|
      host_target.xcconfigs.each do |config_name, config_file|
          frameworksToDelete = Set[]

          host_target.pod_targets.each do |pod_target|
              if embedded_pod_targets.include? pod_target
                  frameworksToDelete.add pod_target.name

                  pod_target.specs.each do |spec|
                      if spec.attributes_hash['ios'] != nil
                          frameworkPaths = spec.attributes_hash['ios']['vendored_frameworks']
                      else
                          frameworkPaths = spec.attributes_hash['vendored_frameworks']
                      end
                      if frameworkPaths != nil
                          frameworkNames = Array(frameworkPaths).map(&:to_s).map do |filename|
                              extension = File.extname filename
                              File.basename filename, extension
                          end
                          frameworkNames.each do |name|
                              frameworksToDelete.add name
                          end
                      end
                  end
              end
          end

          frameworksToDelete.each do |name|
              config_file.frameworks.delete(name)
          end
          xcconfig_path = host_target.xcconfig_path(config_name)
          config_file.save_as(xcconfig_path)
      end
  end
end

def append_header_search_path(target, path)
  target.xcconfigs.each do |config_name, config_file|
    paths = config_file.attributes['HEADER_SEARCH_PATHS'].dup
    paths = paths << " #{path}"

    config_file.attributes['HEADER_SEARCH_PATHS'] = paths

    xcconfig_path = target.xcconfig_path(config_name)
    config_file.save_as(xcconfig_path)
  end
end
