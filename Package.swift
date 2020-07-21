// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "MovableToolbar",
    products: [
        .library(name: "MovableToolbar", targets: ["MovableToolbar"])
    ],
    targets: [
        .target(
            name: "MovableToolbar",
            path: "MovableToolbar",
            exclude: []
        )
    ]
)
