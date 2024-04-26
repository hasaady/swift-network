// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetwork",
    platforms: [.iOS(.v14), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftNetwork",
            targets: ["SwiftNetwork"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftNetwork",
            dependencies: ["Alamofire"]
        ),
        .executableTarget(
            name: "SwiftNetworkDebug",
            dependencies: [
                .target(name: "SwiftNetwork"),
            ]
        ),
        .testTarget(
            name: "SwiftNetworkTests",
            dependencies: ["SwiftNetwork"]),
    ]
)
