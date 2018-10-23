<p>
  <img src="https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/mklogo.png" title="MessageKit logo">
</p>

[![CircleCI](https://circleci.com/gh/MessageKit/MessageKit.svg?style=svg)](https://circleci.com/gh/MessageKit/MessageKit)
[![codecov](https://codecov.io/gh/MessageKit/MessageKit/branch/master/graph/badge.svg)](https://codecov.io/gh/MessageKit/MessageKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<a href="https://swift.org">
 <img src="https://img.shields.io/badge/Swift-4-orange.svg"
      alt="Swift" />
</a>
<a href="https://cocoapods.org/">
  <img src="https://cocoapod-badges.herokuapp.com/v/MessageKit/badge.png"
      alt="CocoaPods">
</a>
<a href="https://developer.apple.com/xcode">
  <img src="https://img.shields.io/badge/Xcode-9-blue.svg"
      alt="Xcode">
</a>
<a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-red.svg"
      alt="MIT">
</a>
<a href="https://github.com/MessageKit/MessageKit/issues">
   <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat"
        alt="Contributions Welcome">
</a>

## Table of Contents

* [**Goal**](#goals)📈
* [**Contributing**](#contributing)
* [**Requirements**](#requirements)
* [**Code of Conduct**](https://github.com/MessageKit/MessageKit/blob/master/CODE_OF_CONDUCT.md)
* [**What's Next**](#whats-next)
* [**Contact**](#contact)
* [**Apps using this library**](#apps-using-this-library)
* [**License**](#license)


## Goals

- Provide a :rotating_light:safe:rotating_light: environment for others to learn and grow through Open Source.
- Make adding Chat:speech_balloon: to a project easy.
- Enable beautiful and customizable Chat UI's.
- Provide an awesome Open Source project for the iOS open source community.
- Help others learn.

## Vision
See [VISION.md](https://github.com/MessageKit/MessageKit/blob/master/VISION.md) for Goals, Scope, & Technical Considerations.


## Installation
### [CocoaPods](https://cocoapods.org/) **Recommended**
````ruby
pod 'MessageKit'
````

If your project is still using Swift 3, you can add the following code to your Podfile:

````ruby
target 'TARGET_NAME' do
    pod 'MessageKit'
    ...
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'MessageKit'
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '4.0'
                end
            end
        end
    end
end
````

### [Carthage](https://github.com/Carthage/Carthage)

To integrate MessageKit using Carthage, add the following to your `Cartfile`:

````
github "MessageKit/MessageKit"
````

## Requirements

- **iOS9** or later


## Contributing

Great! Look over these things first.
- Please read our [Code of Conduct](https://github.com/MessageKit/MessageKit/blob/master/CODE_OF_CONDUCT.md)
- Check the [Contributing Guide Lines](https://github.com/MessageKit/MessageKit/blob/master/CONTRIBUTING.md).
- Come join us on [Slack](https://join.slack.com/t/messagekit/shared_invite/MjI4NzIzNzMyMzU0LTE1MDMwODIzMDUtYzllYzIyNTU4MA) and 🗣 don't be a stranger. 
- Check out the [current issues](https://github.com/MessageKit/MessageKit/issues) and see if you can tackle any of those. 
- Download the project and check out the current code base. Suggest any improvements by opening a new issue. 
- Check out the [What's Next](#whats-next) section :point_down: to see where we are headed.
- Check [StackOverflow](https://stackoverflow.com/questions/tagged/messagekit)
- Install [SwiftLint](https://github.com/realm/SwiftLint) too keep yourself in :neckbeard: style. 
- Be kind and helpful.  


## What's Next?

Check out the [Releases](https://github.com/MessageKit/MessageKit/releases) to see what we are working on next.

## Contact

Have a question or an issue about MessageKit? Create an [issue](https://github.com/MessageKit/MessageKit/issues/new)!

Interested in contributing to MessageKit? Click here to join our [Slack](https://join.slack.com/t/messagekit/shared_invite/MjI4NzIzNzMyMzU0LTE1MDMwODIzMDUtYzllYzIyNTU4MA).

### Apps using this library

Add your app to the list of apps using this library and make a pull request.

- [MediQuo](https://www.mediquo.com)
- [RappresentaMe](https://itunes.apple.com/it/app/rappresentame/id1330914443)
- [WiseEyes](https://itunes.apple.com/us/app/wiseeyes/id1391408511?mt=8)

*Please provide attribution, it is greatly appreciated.*

## Core Team

- [@SD10](https://github.com/sd10), Steven Deutsch
- [@nathantannar4](https://github.com/nathantannar4), Nathan Tannar
- [@zhongwuzw](https://github.com/zhongwuzw), Wu Zhong

## Thanks

Many thanks to [**the contributors**](https://github.com/MessageKit/MessageKit/graphs/contributors) of this project.

## License
MessageKit is released under the [MIT License](https://github.com/MessageKit/MessageKit/blob/master/LICENSE.md).

## Inspiration
Inspired by [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) :point_left: :100:
