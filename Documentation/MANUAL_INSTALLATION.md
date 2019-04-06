## Embedded Framework Installation

- `cd` to your project directory, initialize git, and Add MessageKit as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/MessageKit/MessageKit.git
```

- `cd` to the new `MessageKit` folder and trigger [carthage](https://github.com/Carthage/Carthage) update by the following command:

```bash
$ carthage update --platform iOS
```

- Open `MessageKit` folder, and drag the `MessageKit.xcodeproj` into the Project Navigator of your application's Xcode project. It should appear nested underneath your application's blue project icon.
- Select the `MessageKit.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon), navigate to the target configuration window and select the application target.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `MessageKit.xcodeproj` folders each with two different versions of the `MessageKit.framework` nested inside a `Products` folder.
- Select the top `MessageKit.framework` for iOS and the bottom one for OS X.
- Voila! Now you can `import MessageKit` and build the project.
