// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwordRPC",
  products: [
    .library(
      name: "SwordRPC",
      targets: ["SwordRPC"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/stuartbreckenridge/BlueSocket", .branch("master"))
  ],
  targets: [
    .target(
      name: "SwordRPC",
      dependencies: ["BlueSocket"]
    )
  ]
)
