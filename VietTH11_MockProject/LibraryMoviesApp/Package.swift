// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibraryMoviesApp",
    platforms: [
           .iOS(.v15),
       ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LibraryMoviesApp",
            targets: ["LibraryMoviesApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", from: "10.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LibraryMoviesApp",
            dependencies: ["Alamofire",
                           "Kingfisher",
                           .product(name: "RealmSwift", package: "Realm")
                          ]
        ),
        .testTarget(
            name: "LibraryMoviesAppTests",
            dependencies: ["LibraryMoviesApp"]),
    ]
)
