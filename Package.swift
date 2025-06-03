// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorAppAttest",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorAppAttest",
            targets: ["AppAttestPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "AppAttestPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/AppAttestPlugin"),
        .testTarget(
            name: "AppAttestPluginTests",
            dependencies: ["AppAttestPlugin"],
            path: "ios/Tests/AppAttestPluginTests")
    ]
)