#  Spindl iOS SDK

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
