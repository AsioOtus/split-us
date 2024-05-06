// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-profile",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenProfile",
			targets: [
				"ScreenProfile"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-debug"),
		.package(path: "../../il-components"),
		.package(path: "../../il-logic"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenProfile",
			dependencies: [
				.product(name: "Debug", package: "il-debug"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
