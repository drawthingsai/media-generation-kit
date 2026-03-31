# MediaGenerationKit

`MediaGenerationKit` is a Swift package for local, remote, and Draw Things cloud media generation.

This repository is the public SwiftPM entrypoint for the package. The main implementation continues to live in [`drawthingsai/draw-things-community`](https://github.com/drawthingsai/draw-things-community), and this package re-exports the upstream `MediaGenerationKit` module to provide a stable package URL.

## Requirements

- macOS 13+
- iOS 16+
- Swift 5.9+

## Installation

Add the package to your SwiftPM manifest:

```swift
dependencies: [
  .package(url: "https://github.com/drawthingsai/media-generation-kit.git", branch: "main")
]
```

Then depend on the library product:

```swift
.product(name: "MediaGenerationKit", package: "media-generation-kit")
```

Use a tagged version instead of `branch: "main"` once release tags are available.

## Minimal Example

```swift
import Foundation
import UniformTypeIdentifiers
import MediaGenerationKit

@main
struct ExampleApp {
  static func main() async throws {
    try await MediaGenerationEnvironment.default.ensure(
      "hf://black-forest-labs/FLUX.2-klein-4B"
    )

    var pipeline = try MediaGenerationPipeline.fromPretrained(
      "hf://black-forest-labs/FLUX.2-klein-4B",
      backend: .local
    )

    pipeline.configuration.width = 1024
    pipeline.configuration.height = 1024
    pipeline.configuration.steps = 4
    pipeline.configuration.seed = 42

    let results = try await pipeline.generate(
      prompt: "a red cube on a table",
      negativePrompt: ""
    )

    try results[0].write(
      to: URL(fileURLWithPath: "/tmp/output.png"),
      type: .png
    )
  }
}
```

## Remote Example

```swift
import Foundation
import UniformTypeIdentifiers
import MediaGenerationKit

@main
struct RemoteExampleApp {
  static func main() async throws {
    var pipeline = try MediaGenerationPipeline.fromPretrained(
      "hf://black-forest-labs/FLUX.2-klein-4B",
      backend: .remote(
        .init(host: "127.0.0.1", port: 7860),
        options: .init(useTLS: false)
      )
    )

    pipeline.configuration.width = 1024
    pipeline.configuration.height = 1024
    pipeline.configuration.steps = 4

    let results = try await pipeline.generate(
      prompt: "a red cube on a table",
      negativePrompt: ""
    )

    try results[0].write(
      to: URL(fileURLWithPath: "/tmp/remote-output.png"),
      type: .png
    )
  }
}
```

## Cloud Compute Example

```swift
import Foundation
import UniformTypeIdentifiers
import MediaGenerationKit

@main
struct CloudComputeExampleApp {
  static func main() async throws {
    var pipeline = try MediaGenerationPipeline.fromPretrained(
      "hf://black-forest-labs/FLUX.2-klein-4B",
      backend: .cloudCompute(apiKey: "YOUR_API_KEY")
    )

    pipeline.configuration.width = 1024
    pipeline.configuration.height = 1024
    pipeline.configuration.steps = 4

    let results = try await pipeline.generate(
      prompt: "a red cube on a table",
      negativePrompt: ""
    )

    try results[0].write(
      to: URL(fileURLWithPath: "/tmp/cloud-output.png"),
      type: .png
    )
  }
}
```

## Environment Helpers

`MediaGenerationEnvironment.default` owns process-wide defaults such as:

- `externalUrls`
- `maxTotalWeightsCacheSize`
- `ensure(...)`
- `resolveModel(...)`
- `suggestedModels(...)`
- `inspectModel(...)`
- `downloadableModels(...)`

Example:

```swift
MediaGenerationEnvironment.default.maxTotalWeightsCacheSize =
  8 * 1_024 * 1_024 * 1_024
```

## CLI

This repository also includes the example CLI product:

```bash
swift run media-generation-kit-cli --help
```

Common commands:

```bash
swift run media-generation-kit-cli generate \
  --model hf://black-forest-labs/FLUX.2-klein-4B \
  --width 1024 \
  --height 1024 \
  --num-inference-steps 4 \
  --prompt "a red cube on a table" \
  --output /tmp/output.png

swift run media-generation-kit-cli models ensure \
  --model hf://black-forest-labs/FLUX.2-klein-4B

swift run media-generation-kit-cli lora convert \
  --input ./style.safetensors \
  --output ./style_lora_f16.ckpt

swift run media-generation-kit-cli auth login --provider google
```

For remote generation:

```bash
swift run media-generation-kit-cli generate \
  --remote \
  --remote-url 127.0.0.1 \
  --model hf://black-forest-labs/FLUX.2-klein-4B \
  --width 1024 \
  --height 1024 \
  --num-inference-steps 4 \
  --prompt "a red cube on a table"
```

## Source of Truth

- Public package URL: `https://github.com/drawthingsai/media-generation-kit.git`
- Main implementation: `https://github.com/drawthingsai/draw-things-community.git`

If you want to contribute code, the main implementation repository is the authoritative source.

## License

This repository is licensed under LGPLv3. See [LICENSE](LICENSE).
