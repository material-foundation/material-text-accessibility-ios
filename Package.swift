// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MDFTextAccessibility",
    products: [
        .library(name: "MDFTextAccessibility", targets: ["MDFTextAccessibility"])
    ],
    targets: [
        .target(name: "MDFTextAccessibility")
    ]
)
