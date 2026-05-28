// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPickerKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPickerKit",
            targets: ["SwiftPickerKit"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftPickerKit"
        ),
        .testTarget(
            name: "SwiftPickerKitTests",
            dependencies: ["SwiftPickerKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
