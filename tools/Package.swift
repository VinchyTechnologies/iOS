// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "tools",
  platforms: [.macOS(.v10_11)],
  dependencies: [
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
  ],
  targets: [.target(name: "tools", path: "")])
