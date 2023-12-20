#  Spindl iOS SDK

## Spindl Developers

Here are the steps for making a new version of the SDK.

1. Make new public methods or modify functionality in `Spindl.swift`.
2. You can test with unit tests in the same project:
    1. Go to the Unit Test tab in the left pane:
    ![diamond with a checkmark, sixth from the left](https://cvws.icloud-content.com/B/ATn8g5Dfm7PfVLLMqLP3nVIl1wADARKEJqgT0I7PnZAVpp7ETt1OuI9Z/Unit%20Test%20Tab%20in%20Xcode.png?o=AgsdgqvtEY_tYCK-rxlrdPRU3-0ssN507Dy7OznYF2bP&v=1&x=3&a=CAogyXnVZkXGqUYJU1r-yGYxX1qItAT2WH9jnB9ufIPQ5gASaRChwcefyDEYoZ6jocgxIgEAUgQl1wADWgROuI9ZaiQGSwShqGrNMNj_vmH_R6ztbnU-NCabsfe29iD5AWKbO6E4qbRyJE4TAXCdtwRssaZlwIQZNFh6P132kQpmS4KbBKzPQOMZjcHxCg&e=1703024316&fl=&r=ba05ffac-73bd-4f18-8862-67d5bba35409-1&k=alPxs1UJhK2YOfCXHUr8jQ&ckc=com.apple.clouddocs&ckz=com.apple.CloudDocs&p=40&s=OgsmgepQlxawWz-R3QIgVcUMs7w&+=906cc7d4-bf76-4f40-9bfb-205a7d85787a "Unit Test Tab")
    2. Hover over the desired test or test group entry in the outline. A Play arrow button will appear on the right side, next to the item. Previously run tests have a solidly visible status indicator in this position, which will turn into a Play button when hovering over it.
    3. Press the Play button that appeared to run the test or the test group.
    4. Double clicking any of these items will open up the unit test code. 
    5. Tests can be run from inside this source file as well: to run a test, click on the empty diamond in the line number gutter, corresponding to the function declaration. To run all tests, click on the empty diamond next to the class declaration.
1. To test with an app:
    1. Close the SDK project.
    1. Checkout the sdk-examples iOS app or make another app.
    1. Add a local Package reference to the SDK project. 
    1. The source code will be visible under the local package reference in the file tree. Breakpoints, editing, etc. all should work.
3. To release:
    1. Commit changes to the SpindlSDK repository (not the example app).
    1. Tag the commit with a new version number.
    1. Push the commit and tag to GitHub.
