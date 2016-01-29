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
Installs FixCode which disables the "Fix Issue" button in Xcode
### analyze
```
fastlane analyze
```
Runs linting (and eventually static analysis)
### test
```
fastlane test
```
Runs all unit tests.
### beta
```
fastlane beta
```
Submit new **Beta** build to Hockey app
### upload_to_hockey
```
fastlane upload_to_hockey
```

### appstore
```
fastlane appstore
```
Deploy new version to the App Store (and also hockey app)
### set_environment
```
fastlane set_environment
```
Sets environment.plist app_name and app_bundle_id according to scheme
### testing
```
fastlane testing
```


----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools)
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane)