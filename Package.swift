// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-eu-ecli",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "EU ECLI", targets: ["EU ECLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-iso/swift-iso-3166.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-8601.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "EU ECLI",
            dependencies: [
                .product(name: "ISO 3166", package: "swift-iso-3166"),
                .product(name: "ISO 8601", package: "swift-iso-8601"),
            ]
        ),
        .testTarget(
            name: "EU ECLI Tests",
            dependencies: [
                .target(name: "EU ECLI")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
