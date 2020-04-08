// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MessageKit",
    products: [
        .library(name: "MessageKit", type: .dynamic, targets: ["MessageKit"])
    ],
    dependencies: [
        // Dev dependencies
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.38.2"), // dev
    ],
    targets: [
        .target(name: "MessageKit", path: "Sources"),
        .testTarget(name: "MessageKitTests", dependencies: ["MessageKit"], path: "Tests"), // dev
    ]
)
