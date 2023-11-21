// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpindlSDK",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpindlSDK",
            targets: ["SpindlSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marcoarment/Blackbird.git", .upToNextMajor(from: "0.0.1")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMajor(from: "0.6.7"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpindlSDK",
            dependencies: ["Blackbird", "AnyCodable"]),
        .testTarget(
            name: "SpindlSDKTests",
            dependencies: ["SpindlSDK"]),
    ]
)
