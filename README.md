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
1. Choose  `0.0.4-alpha` and `Up to next major version`, and click the `Add Package` button to dismiss the dialog.
1. Switch from the Project to the main Target in the pane on the left.
1. Go to the `General` tab.
1. Scroll down to `Frameworks, Libraries, and Embedded Content` section.
1. Add `SpindlSDK` if it isn't already listed.

## Usage

Initialize the SDK with your API key upon launching the app, usually in the `AppDelegate`, or `App` protocol implementor:

```swift
import SpindlSDK

struct MyApp : App {

  init() {
    Spindl.initialize("<your API key goes here>")
  }
  
  ...
}
```

Once customers enter their ID and/or wallet information (e.g., after logging in), connect that to the analytics by calling the `identify` method of the `Spindl` singleton:

```swift
struct MyLoginView : View {
    ...

    private func saveUserIdentityExample(wallet: String?, email: String?) async throws {
        try await Spindl.shared.identify(walletAddress: wallet, customerUserId: email)
        ...
    }
```

Track events with the `track` method:

```swift
    private func myButtonTappedExample() async throws {
        try await Spindl.shared.track(name: "myButtonTapped", properties: ["view":"MyFancyView","otherProperty":"Another one"])
        ...
    }
```

## Spindl Developers

Here are the steps for making a new version of the SDK.

1. Make new public methods or modify functionality in `Spindl.swift`.
2. You can test with unit tests in the same project. Or, to test with an app:
    1. Close the SDK project.
    1. Checkout the sdk-examples iOS app or make another app.
    1. Add (or replace) a local  Package reference to the SDK project. Breakpoints, editing, etc. all should work underneath the local SpindlSDK package reference.
3. To release:
    1. Commit changes to the SpindlSDK repository (not the example app).
    1. Tag the commit with a new version number.
    1. Push the commit and tag to Github.
