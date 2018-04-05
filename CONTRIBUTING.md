# Contributing Guidelines

### Code of Conduct

Please read our [Code of Conduct](https://github.com/MessageKit/MessageKit/blob/master/Code_of_Conduct.md). 
The MessageKit maintainers take this Code of Conduct very seriously. Intolerance, disrespect, harassment, and any form of negativity will not be tolerated.

### Ways to Contribute

You can contribute to MessageKit in a variety of ways:

- Fixing or reporting bugs :scream:
- Improving documentation :heart:
- Suggesting new features :smiley:
- Increasing unit test coverage :pray:
- Resolving any open issues :+1:

If you're new to Open Source or Swift, the MessageKit community is a great place to get involved.

**Your contributions are always welcome, no contribution is too small.**

### Opening a New Issue

- Please check the [README](https://github.com/MessageKit/MessageKit/blob/master/README.md) to see if your question is answered there.
- Search [open issues](https://github.com/MessageKit/MessageKit/issues?q=is%3Aopen+is%3Aissue) and [closed issues](https://github.com/MessageKit/MessageKit/issues?q=is%3Aissue+is%3Aclosed) to avoid opening a duplicate issue.
- Avoiding duplicate issues organizes all relevant information for project maintainers and other users.
- If no issues represent your problem, please open a new issue with a good title and useful description.

- Information to Provide When Opening an Issue: 
    - MessageKit version(s)
    - iOS version(s)
    - Devices/Simulators affected
    - Full crash log, if applicable
    - A well written description of the problem you are experiencing
    - *Please provide complete steps to reproduce the issue* 
    - For UI related issues, please provide a screenshot/GIF/video showing the issue 
    - Link to a project or demo project that exhibits the issue 
    - Search for a list any issues that might be related

The more information you can provide, the easier it will be for us to resolve your issue in a timely manner.

### Submitting a Pull Request

We maintain two permanent, protected branches: `master` and `development`.

`master` is for working on the current release, so any bug fixes or documentation spelling fixes should be merged into this branch.

`development` is where we stage work for the *next* release, i.e. breaking API changes and related documentation updates. Contributors should gently encourage new pull-requests to point to the appropriate branch, and to rebase onto that branch if necessary.

When a new version is ready to be released, please create a pull request to merge `development` into `master`, named something like "Release 10.0". Then we can have some final discussion before we merge it into `master` and push the release out to the public.

Since `development` is a *shared* branch, it is important not to ever rebase this branch onto `master`. If a bug fix is applied to `master` it can be merged into `development` using good old simple `git checkout development && git merge master`. Yes this will clutter the history a little bit, but it also provides important context to know how/when a patch was applied. Merge commits can be considered necessary historical data, not warts on an idealized history graph.

**You should submit one pull request per feature, the smaller the pull request the better chances it will be merged.**
Enormous pull requests take a significant time to review and understand their implications on the existing codebase.

### Style Guidelines

Writing clean code and upholding project standards is as important as adding new features. To ensure this, MessageKit employs a few practices:

1. We use [SwiftLint](https://github.com/realm/SwiftLint) to enforce style and conventions at compile time.
2. We adhere to the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).
3. We follow the [Raywenderlich Swift Style Guide ](https://github.com/raywenderlich/swift-style-guide) but may have slight variations. 

### Questions and Contact

If any of the sections above are unclear and require further explanation, *do not hesitate to reach out*.
MessageKit strives to build an inclusive open source community and to make contributing as easy as possible for members of all experience levels.

**You can get in touch with the MessageKit core team directly by joining our open Slack community channel: [here](https://join.slack.com/t/messagekit/shared_invite/MjI0NDkxNjgwMzA3LTE1MDIzMTU0MjUtMzJhZDZlNTkxMA).**

----

## [No Brown M&M's](http://en.wikipedia.org/wiki/Van_Halen#Contract_riders)

If you made it all the way to the end, bravo dear user, we love you. You can include this emoji in the top of your ticket to signal to us that you did in fact read this file and are trying to conform to it as best as possible: :ghost:
