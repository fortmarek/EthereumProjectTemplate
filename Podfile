# Podfile
source 'git@gitlab.ack.ee:Ackee/AckeePods.git' # Ackee private repo
source 'https://github.com/CocoaPods/Specs.git' # Default Cocoapods repo

platform :ios, '9.0'
project 'ProjectSkeleton', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

use_frameworks!
inhibit_all_warnings!

target 'ProjectSkeleton' do

pod 'ACKategories', '~> 4.0'
pod 'HockeySDK', '~> 4.1'

pod 'SwiftGen', '~> 3.0'
pod 'Locksmith', '~> 3.0'
pod 'SwinjectAutoregistration', :git => 'https://github.com/Swinject/SwinjectAutoregistration.git', :branch => 'release2.0'
pod 'ReactiveCocoa', '5.0.0-alpha.2'
pod 'ReactiveSwift', '1.0.0-alpha.3'
pod 'ACKReactiveExtensions', '~> 2.0'
pod 'ACKReactiveExtensions/Argo', '~> 2.0'

pod 'SnapKit', '~> 3.0'
pod 'SDWebImage', '~> 3.8'
pod 'TPKeyboardAvoiding', '~> 1.3'

pod 'Alamofire', '~> 4.0'
pod 'Argo', '~> 4.0'
pod 'Curry', '~> 3.0'

def testing_pods
    pod 'Quick', '~> 0.10'
    pod 'Nimble', '~> 5.1'
end


target 'Tests' do
    inherit! :search_paths
    testing_pods
end

target 'UITests' do
    inherit! :search_paths
    testing_pods
end

target 'APITests' do
    inherit! :search_paths
    testing_pods
end

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
