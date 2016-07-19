# Podfile

platform :ios, '8.0'
xcodeproj 'GrenkePlayground', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

use_frameworks!

pod 'ACKategories', :git => 'https://github.com/AckeeCZ/ACKategories.git'
pod 'HockeySDK'
#pod 'FlurrySDK'


#pod 'SVProgressHUD'
pod 'SnapKit'
pod 'Alamofire'
pod 'ReactiveCocoa', '4.0.0-alpha-3'
pod 'Argo', '~> 2.2'
pod 'Curry', '~> 1.4'
pod 'Swinject', '~> 1.0.0'
pod 'SwiftGen', '~> 0.7.6'

pod 'Locksmith', '~> 2.0.8'


#pod 'Reachability'

#pod 'MagicalRecord', '~> 2.2'
#pod 'SVProgressHUD', :head
pod 'SDWebImage', '~> 3.6'
#pod 'Reachability'
pod 'TPKeyboardAvoiding'

def testing_pods
    pod 'Quick', '~> 0.9.2'
    pod 'Nimble', '4.0.1'
end

#testing_pods

target :Tests, :exclusive => true do
    testing_pods
end

target :UITests, :exclusive => true do
    testing_pods
end

target :APITests, :exclusive => true do
    testing_pods
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
    
    puts 'changing bundle versions to conform to testfligh rules'
    plist_buddy = "/usr/libexec/PlistBuddy"
    
    installer.pods_project.targets.each do |target|
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{plist}"`.strip
        
        stripped_version = /([\d\.]+)/.match(version).captures[0]
        
        version_parts = stripped_version.split('.').map { |s| s.to_i }
        
        # ignore properly formatted versions
        unless version_parts.slice(0..2).join('.') == version
            
            major, minor, patch = version_parts
            
            major ||= 0
            minor ||= 0
            patch ||= 999
            
            fixed_version = "#{major}.#{minor}.#{patch}"
            
            puts "Changing version of #{target} from #{version} to #{fixed_version} to make it pass iTC verification."
            
            `#{plist_buddy} -c "Set CFBundleShortVersionString #{fixed_version}" "#{plist}"`
        end
    end
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
