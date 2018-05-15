source "https://rubygems.org"

gem "cocoapods", '~> 1.5'
gem "fastlane", '~> 2.95'
gem "xcode-install", '~> 2.3'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
