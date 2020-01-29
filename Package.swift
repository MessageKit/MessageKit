// swift-tools-version:5.0
import PackageDescription

let package = Package(
   name: "MessageKit",
   platforms: [.iOS(.v9)],
   products: [
       .library(name: "MessageKit",
                targets: ["MessageKit"])
   ],
   dependencies: [
        .package(url: "https://github.com/Nixon506E/InputBarAccessoryView.git", from: "4.2.1")
   ],
   targets: [
       .target(
           name: "MessageKit",
           dependencies: ["InputBarAccessoryView"],
           path: "Sources"
       )
   ],
   swiftLanguageVersions: [.v5]
)
