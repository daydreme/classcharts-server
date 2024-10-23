// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "classcharts-api-server",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "ApiModels", targets: ["ApiModels"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.106.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.8.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing", from: "0.1.3"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.5.6"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.0.0-rc"),
    ],
    targets: [
        .executableTarget(
            name: "ClassChartsAPIServer",
            dependencies: [
                "ApiModels",
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "VaporRouting", package: "vapor-routing"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .target(name: "ApiModels"),
    ]
)
