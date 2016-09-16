fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### xcode
```
fastlane xcode
```
Installs FixCode which disables the "Fix Issue" button in Xcode, Swimat and Fuzzy 
### analyze
```
fastlane analyze
```
Runs linting (and eventually static analysis)
### test
```
fastlane test
```
Runs unit, api and ui tests.
### screenshots
```
fastlane screenshots
```
Create new screenshots for the App Store in all languages and device types

Additionally, this will add device frames around the screenshots
### copy
```
fastlane copy
```
Copies and renames the project into new directory
### provisioning
```
fastlane provisioning
```
Downloads provisioning for all environments
### beta
```
fastlane beta
```
Submit new **beta** build to Hockey app
### appstore
```
fastlane appstore
```
Deploy new version to the App Store (and also hockey app)
### set_environment
```
fastlane set_environment
```
Switches environment and sets app_name and app_identifier in plist

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
