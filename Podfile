# Podfile

platform :ios, '8.0'
xcodeproj 'ProjectName', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

use_frameworks!

pod 'ACKategories', :git => 'https://github.com/AckeeCZ/ACKategories.git'
pod 'HockeySDK'
pod 'FlurrySDK'


#pod 'SVProgressHUD'
#pod 'SnapKit'
#pod 'AlamoFire'

#pod 'MagicalRecord', '~> 2.2'
#pod 'SVProgressHUD', :head
#pod 'SDWebImage', '~> 3.6'
pod 'Reachability'



target :Tests, :exclusive => true do
    #pod 'Kiwi'
    #pod 'Kiwi/XCTest'

end

post_install do |installer|
    
    puts 'Setting appropriate code signing identities'
    installer.pods_project.targets.each { |target|
        {
            'iPhone Developer' => ['Development','Debug'],
            'iPhone Distribution' => ['AppStore','AdHoc','Release'],
        }.each { |value, configs|
            target.set_build_setting('CODE_SIGN_IDENTITY[sdk=iphoneos*]', value, configs)
        }
    }
    
end

class Xcodeproj::Project::Object::PBXNativeTarget
    
    def set_build_setting setting, value, config = nil
        unless config.nil?
            if config.kind_of?(Xcodeproj::Project::Object::XCBuildConfiguration)
                config.build_settings[setting] = value
                elsif config.kind_of?(String)
                build_configurations
                .select { |config_obj| config_obj.name == config }
                .each { |config| set_build_setting(setting, value, config) }
                elsif config.kind_of?(Array)
                config.each { |config| set_build_setting(setting, value, config) }
                else
                raise 'Unsupported configuration type: ' + config.class.inspect
            end
            else
            set_build_setting(setting, value, build_configurations)
        end
    end
    
end