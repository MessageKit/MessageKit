// swift-tools-version:5.6

// MIT License
//
// Copyright (c) 2017-2022 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import PackageDescription

let package = Package(
    name: "MessageKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "MessageKit", targets: ["MessageKit"]),
        .plugin(name: "SwiftLintPlugin", targets: ["SwiftLintPlugin"]),
        .plugin(name: "SwiftFormatPlugin", targets: ["SwiftFormatPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nathantannar4/InputBarAccessoryView", .upToNextMajor(from: "6.1.0")),
    ],
    targets: [
        // MARK: - MessageKit

        .target(
            name: "MessageKit",
            dependencies: ["InputBarAccessoryView"],
            path: "Sources",
            exclude: ["Supporting/Info.plist", "Supporting/MessageKit.h"],
            swiftSettings: [SwiftSetting.define("IS_SPM")]
        ),
        .testTarget(name: "MessageKitTests", dependencies: ["MessageKit"]),

        // MARK: - Plugins

        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.47.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "82ef90b7d76b02e41edd73423687d9cedf0bb9849dcbedad8df3a461e5a7b555"
        ),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLintCommandPlugin",
            capability: .command(
                intent: .custom(
                    verb: "lint",
                    description: "Lint Swift source files"
                )
            ),
            dependencies: ["SwiftLintBinary"]
        ),

        .binaryTarget(
            name: "swiftformat",
            url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.49.13/swiftformat.artifactbundle.zip",
            checksum: "5ce27780dceee8714b15d53141e6dce1a8d626e970eade3c511c9ef1a0c06f40"
        ),
        .plugin(
            name: "SwiftFormatPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "Format Swift source files"),
                ]
            ),
            dependencies: ["swiftformat"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
