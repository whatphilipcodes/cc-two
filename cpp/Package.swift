// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "AberrProject",
  platforms: [.iOS(.v17), .macOS(.v14)],
  products: [
    .library(name: "AberrPackage", targets: ["AberrPackage"]),
    .executable(name: "AberrCLI", targets: ["AberrCLI"]),
  ],
  targets: [
    // C++ library target
    .binaryTarget(
      name: "LibRaw",
      path:
        "External/build/LibRaw/local/LibRaw.xcframework"
    ),
    .target(
      name: "AberrCore",
      dependencies: ["LibRaw"],
      path: "Sources/AberrCore",
      publicHeadersPath: "include",
      cxxSettings: [
        .headerSearchPath("include"),
        .define("SWIFT_PACKAGE"),
      ],
      linkerSettings: [
        .linkedLibrary("z"),
        //.linkedLibrary("lcms2")
      ]
    ),
    // Swift wrapper target
    .target(
      name: "AberrPackage",
      dependencies: ["AberrCore"],
      path: "Sources/AberrPackage",
      swiftSettings: [
        // enable C++ interop
        .interoperabilityMode(.Cxx)
      ]
    ),
    // CLI executable target
    .executableTarget(
      name: "AberrCLI",
      dependencies: ["AberrPackage"],
      path: "Sources/AberrCLI",
      swiftSettings: [
        .interoperabilityMode(.Cxx)
      ]
    ),
  ]
)
