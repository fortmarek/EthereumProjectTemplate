# Podfile
source 'git@gitlab.ack.ee:Ackee/AckeePods.git' # Ackee private repo
source 'https://github.com/CocoaPods/Specs.git' # Default Cocoapods repo

platform :ios, '9.0'
project 'ProjectSkeleton', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

inhibit_all_warnings!
use_frameworks!

target 'ProjectSkeleton' do
    
    # Extensions
    pod 'ACKategories', '~> 4.0'
    pod 'ACKReactiveExtensions', :git => 'https://github.com/AckeeCZ/ACKReactiveExtensions.git', :branch => 'pod-update'
    
    # UI
    pod 'SnapKit'
    pod 'TPKeyboardAvoiding'
    pod 'AlamofireImage'
    
    # Networking
    pod 'Alamofire'
    
    # Model
    pod 'ReactiveCocoa', '~> 6.0'
    pod 'ReactiveSwift', '~> 2.0'
    pod 'Locksmith', '~> 3.0'
    
    # Dependency Injection
    pod 'Swinject', '~> 2.0'
    pod 'SwinjectAutoregistration', :git => 'https://github.com/Swinject/SwinjectAutoregistration.git', :branch => 'swift4'
    
    pod 'Firebase/RemoteConfig'

    # Hockey
    pod 'HockeySDK', '~> 4.1'

    # Code Generation
    pod 'SwiftGen', '~> 4.0'

    target 'Tests' do
        inherit! :search_paths
    end

    target 'UITests' do
        inherit! :search_paths
    end
end

post_install do |installer|

    #Legacy swift targets
    legacy_swift_targets = ["ReactiveCocoa", "SnapKit", "ACKategories", "AlamofireImage", "ACKReactiveExtensions"]
    
    installer.pods_project.targets.each do |target|
        if legacy_swift_targets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end


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
