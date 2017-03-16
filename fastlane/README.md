fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools/fastlane.zip">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>
# Available Actions
### xcode
```
fastlane xcode
```
Installs templates and snippets 
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
### localization
```
fastlane localization
```
Download strings from Google spreadsheet
### swiftgen
```
fastlane swiftgen
```
Generate SwiftGen enums
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
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
