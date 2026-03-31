// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "media-generation-kit",
  platforms: [.macOS(.v13), .iOS(.v16)],
  products: [
    .library(name: "MediaGenerationKit", targets: ["MediaGenerationKit"]),
    .executable(name: "media-generation-kit-cli", targets: ["MediaGenerationKitCLI"]),
  ],
  dependencies: [
    // Use a tagged upstream release before publishing this wrapper package.
    .package(url: "https://github.com/drawthingsai/draw-things-community.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
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
