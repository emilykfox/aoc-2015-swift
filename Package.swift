// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AoC2015",
  platforms: [
    .macOS(.v26)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-collections", "1.2.0"..<"1.3.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "Day01"
    ),
    .executableTarget(
      name: "Day02"
    ),
    .executableTarget(
      name: "Day03"
    ),
    .target(
      name: "MD5"
    ),
    .testTarget(
      name: "MD5Tests",
      dependencies: [
        .target(name: "MD5")
      ]
    ),
    .executableTarget(
      name: "Day04",
      dependencies: [
        .target(name: "MD5")
      ]
    ),
    .executableTarget(
      name: "Day05"
    ),
    .executableTarget(
      name: "Day06"
    ),
    .executableTarget(
      name: "Day07"
    ),
    .executableTarget(
      name: "Day08"
    ),
    .executableTarget(
      name: "Day09"
    ),
    .executableTarget(
      name: "Day10"
    ),
    .executableTarget(
      name: "Day11"
    ),
  ],
  swiftLanguageModes: [.v6],
)
