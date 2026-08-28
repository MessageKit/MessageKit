## Manual Installation

Most projects should add MessageKit as a [Swift Package Manager](https://swift.org/package-manager/)
dependency, which the [README](../README.md#installation) describes.

Use the steps below when you want the source in your own repository instead: to
build against a fork, to pin a vendored copy, or to make local changes to
MessageKit alongside your app.

### Requirements

MessageKit needs **iOS 14** or later and builds in the **Swift 6** language mode,
so you need **Xcode 16** or later.

### Add the source to your repository

`cd` to your project directory and add MessageKit as a git
[submodule](https://git-scm.com/docs/git-submodule):

```bash
$ git submodule add https://github.com/MessageKit/MessageKit.git
```

### Add the package to your project

- Drag the new `MessageKit` folder from Finder into the Project Navigator of
  your application's Xcode project. Xcode reads the `Package.swift` file in that
  folder and adds it as a local package, which shows up with a package icon
  rather than a blue project icon.
- Select your application target, open the **General** panel, and find the
  **Frameworks, Libraries, and Embedded Content** section.
- Click the `+` button and select the `MessageKit` library.

You can also skip the drag step and use **File ▸ Add Package Dependencies…**,
then the **Add Local…** button, and choose the `MessageKit` folder.

Now you can `import MessageKit` and build the project.

### A note on dependencies

This does not give you an offline build. MessageKit depends on
[InputBarAccessoryView](https://github.com/nathantannar4/InputBarAccessoryView),
and Swift Package Manager still resolves that dependency over the network even
though MessageKit itself is local. To build without network access you have to
vendor that package the same way and point your local copy of MessageKit at it.

### A working example

The [example app](../Example) in this repository uses exactly this setup. Its
Xcode project references the package root as a folder and links the `MessageKit`
library product from it, so open `Example/ChatExample.xcodeproj` if you want to
see the result of these steps in a project that CI builds on every pull request.
