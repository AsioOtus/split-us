// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-utils",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILUtils",
			targets: [
				"ILUtils",
			]
		)
	],
	dependencies: [
		.package(
			path: "../dl-utils"
		),

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
			name: "ILUtils",
			dependencies: [
				.product(
					name: "DLUtils",
					package: "dl-utils"
				),

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
