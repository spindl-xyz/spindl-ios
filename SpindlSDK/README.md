#  Spindl iOS SDK

## Installing Spindl SDK

### Swift Package Manager

Add the SpindlSDK package to your target dependencies.

```swift

import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/spindl/spindl-ios",
        from: "0.0.4-alpha"
    ),
  ]
)

```

Or in Xcode:

1. Select the Project in the file hierarchy pane.
1. In the Project and Target settings editor, choose the Project.
1. Open the `Package Dependencies` tab.
1. Click the + button to open the `Add Package` dialog.
1. Enter the URL `https://github.com/spindl` and choose `spindl-ios`.
1. Choose  `0.0.4-alpha` and `Up to next major version`.



