// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CleanPaste",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "CleanPasteApp", targets: ["CleanPasteApp"]),
        .executable(name: "cleanpaste", targets: ["cleanpaste"]),
        .library(name: "CleanPasteCore", targets: ["CleanPasteCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.6.0"),
    ],
    targets: [
        // Converter, clipboard and options shared by the app and the CLI.
        .target(name: "CleanPasteCore", path: "Sources/CleanPasteCore"),
        // Menu bar app.
        .executableTarget(
            name: "CleanPasteApp",
            dependencies: ["CleanPasteCore", .product(name: "Sparkle", package: "Sparkle")],
            path: "Sources/CleanPaste",
            linkerSettings: [
                // Sparkle.framework is embedded in Clean Paste.app/Contents/Frameworks
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"]),
            ]
        ),
        // Command line tool, shipped in Clean Paste.app/Contents/Helpers.
        .executableTarget(name: "cleanpaste", dependencies: ["CleanPasteCore"], path: "Sources/CLI"),
    ]
)
