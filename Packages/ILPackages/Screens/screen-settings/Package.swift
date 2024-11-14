// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-settings",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenSettings",
			targets: [
				"ScreenSettings"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-debug"),
		.package(path: "../../il-debug-tca"),
		.package(path: "../../il-components"),
		.package(path: "../../il-logic"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenSettings",
			dependencies: [
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "ILDebugTCA", package: "il-debug-tca"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
