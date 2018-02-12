# Ackee iOS project skeleton

## Installation

iOS project skeleton uses [Carthage](https://github.com/Carthage/Carthage) and Ruby [Bundler](http://bundler.io).

I recommend always running on latest Carthage version. Carthage could be installed by running:
```bash
brew update
brew install carthage
```

Bundler should be a part of your Ruby installation. I recommend ruby version greater than 2.4.x. If you don't have bundler than it can be installed by running:
```bash
sudo gem install bundler
```

After checking out the project run

```bash
bundle install
```

This will install all needed gems to run the skeleton and maintain their versions appropriately. From now on fastlane shouldn't be run directly but through Bundler.

```bash
bundle exec fastlane ...
```

## Project setup

When creating new project, desired steps should be
1. copy skeleton content into new directory and open it
2. remove `.git` directory
```bash
rm -rf .git
```
3. create new git repository
```bash
git init
```
4. rename skeleton files
```bash
bundle exec fastlane rename name:NewProject
```
if the `name` argument is ommitted, the script will prompt for it.

5. Update `Jenkinsfile` with correct Slack channel for CI and correct HockeyApp app identifier
6. Update `Fastfile` with correct HockyApp app identifier (used when calling `bundle exec fastlane beta` on local machine), if you already have production developer account and iTC account, you can fill also those credentials

Now project should be ready to start.

## Dependency management

Now preferred way of dependency management is [Carthage](https://github.com/Carthage/Carthage). Only dependencies which do not support it can be integrated using [Cocoapods](https://cocoapods.org).

### Carthage

At first I recommend [the official Carthage README](https://github.com/Carthage/Carthage/blob/master/README.md). This is just a basic tutorial for most common commands.

Generally Carthage uses two main files - **Cartfile** which holds list of dependencies (equal to *Podfile* in *Cocoapods*) and **Cartfile.resolved** which holds real versions that were installed (equal to *Podfile.lock* in *Cocoapods*)

#### Installing resolved versions

To install previously resolved versions of dependencies (all in Cartfile.resolved) run:
```bash
carthage bootstrap --platform iOS --cache-builds
```

This will install all dependencies in Cartfile.resolved and build them for the iOS platform.

***NOTE: If you have added any dependency to Cartfile, it will not be installed as it is not yet in the Cartfile.resolved file, so it isn't equivalent to `pod install` command***

#### Installing new dependency

If you're adding a new dependency - you want Carthage to add it to the Cartfile.resolved file, you should run:
```bash
carthage update --platform iOS --cache-builds <dependency_name>
```

If the dependency already existed it will be updated according to specified version in Cartfile. If the `dependency_name` argument is omitted, Carthage will install the newest versions of all dependencies according to Cartfile so be careful.

`carthage update` should be equivalent to calling `pod update` in Cocoapods.

#### Updating dependencies

This will update all dependecies from Cartfile (like if Cartfile.resolved never existed)

```bash
carthage update --platform iOS --cache-builds
```

#### Useful stuff for Carthage

I use some aliases for bash which simplify Carthage calls

```bash
alias cb='carthage bootstrap --platform iOS --cache-builds --no-use-binaries'
alias cu='carthage update --platform iOS --cache-builds --no-use-binaries'
```

The `--no-use-binaries` option might be omitted, right now I'm not sure what exactly suits our needs.

For complete dependency management there is a lane `cart` which runs `carthage bootstrap` with some default parameters so you don't have to care really.
```bash
bundle exec fastlane cart
```

To resolve all dependencies at once you can use `dependencies` lane
```bash
bundle exec fastlane dependencies
```

### Cocopoads

If your dependency doesn't support Carthage or it doesn't make sense (SwiftGen, ACKLocalization, ...) just integrate it using Cocoapods.

## Project structure

The project structure should be more-targets-ready so every target has its own folder.

### Bundle identifier

We are back to the pattern where bundle identifier is driven by configuration. (`PRODUCT_BUNDLE_IDENTIFIER` variable in build settings). This approach simplifies the code signing process significantly.

### Build number

Build number was moved back to preprocess header which is ignored in git so changing environment doesn't trigger any changes in it.

### Project version name

Project version name is defined top project itself using `ACK_PROJECT_VERSION` build setting, because e.g. push notification extensions require that the extension has the same version as main app, so it can be held on a single place and inherited.

### Environment switch

Environment switch has moved from separate aggregate target to a build phase of the app target, because in multiple target environment it becomes a bit confusing.

Also environment is now a directory so all environment specific files should be inside, this allows adding another environment specific files without touching the Fastfile or the environment switch build phase. All you have to do is just to add it to Xcode project under current environment.

Also current environment is ignored in git so environment changes don't trigger changes in it.

Current environment for concrete scheme is selected in its pre-build action.

#### Access environment values from code

In code environment values are now accessed using generated `Environment` enum. The generator script supports almost all value types that plist can hold, but there are some conventions.

Supported types:
- `Dictionary` - generated as nested `enum`, first letter is capitalized
- `URL` - string whose key has suffix `URL` and can be converted to `URL`
- `Bool` - bool or number whose key has prefix `is` and can be converted to `Bool` (plist serialization cannot determine between `true`/`false` and `0`/`1`)
- `Int`
- `Double`
- `Date`
- `Data`

The generated file is checked by compilator in compile time.

### Google plists

Google plists are switch in a build phase according to current build configuration (they depend on bundle identifier) and then there are copied into current environment directory.

## App release

The `appstore` lane was renamed to `release` lane so it doesn't interfere with built-in fastlane action.

According to #procesy the username used to access developer portal and iTC should be the same as your git username. If you need to customize this behavior you can override the `itc_apple_id()` or `dev_portal_apple_id()` function.

Release lane just uploads build to iTC (it uses `testflight` action instead of `deliver`) so it just requires *Developer* permission on iTC.
