source 'git@gitlab.ack.ee:Ackee/AckeePods.git' # Ackee private repo
source 'https://github.com/CocoaPods/Specs.git' # Default Cocoapods repo

platform :ios, '10.3'
project 'Skeleton', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

inhibit_all_warnings!
use_frameworks!

target 'Skeleton' do
    pod 'SwiftGen', '~> 5.2'
    pod 'SwiftLint', '~> 0.24'
    pod 'ACKLocalization', '~> 0.2'
    pod 'Crashlytics', '~> 3.9'

    pod 'Firebase', '~> 4.0', :subspecs => ["RemoteConfig", "Performance", "Analytics", "Messaging"]
    
    target 'UnitTests' do
        inherit! :complete
    end
    
    target 'UITests' do
        inherit! :complete
    end
end
