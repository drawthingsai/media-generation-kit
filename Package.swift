// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "MediaGenerationKit",
  platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16), .visionOS(.v1)],
  products: [
    .library(name: "MediaGenerationKit", targets: ["MediaGenerationKit"]),
    .executable(name: "media-generation-kit-cli", targets: ["MediaGenerationKitCLI"]),
  ],
  dependencies: [
    // Use a tagged upstream release before publishing this wrapper package.
    .package(url: "https://github.com/drawthingsai/draw-things-community.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.5"),
  ],
  targets: [
    .target(
      name: "MediaGenerationKit",
      dependencies: [
        .product(name: "_MediaGenerationKit", package: "draw-things-community")
      ]
    ),
    .executableTarget(
      name: "MediaGenerationKitCLI",
      dependencies: [
        "MediaGenerationKit",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
  ]
)
