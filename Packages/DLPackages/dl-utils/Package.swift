// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-utils",
	platforms: [
		.iOS(.v16),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "DLUtils",
			targets: [
				"DLUtils",
			]
		)
	],
	dependencies: [
		.package(
			url: "https://github.com/AsioOtus/multitool",
			from: "1.0.0"
		),
		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			exact: "1.8.0"
		),
	],
	targets: [
		.target(
			name: "DLUtils",
			dependencies: [
				.product(
					name: "Multitool",
					package: "multitool"
				),
				.product(
					name: "ComposableArchitecture",
					package: "swift-composable-architecture"
				),
			]
		),
	]
)
