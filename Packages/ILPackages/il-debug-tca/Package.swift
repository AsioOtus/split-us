// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-debug-tca",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILDebugTCA",
			targets: [
				"ILDebugTCA"
			]
		)
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-network"),
		.package(path: "../../DLPackages/dl-services"),
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../il-formatters"),
		.package(path: "../il-logic"),
		.package(path: "../il-debug"),
		.package(url: "https://github.com/AsioOtus/network-util", from: "2.0.0"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.3.5"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ILDebugTCA",
			dependencies: [
				.product(name: "DLNetwork", package: "dl-network"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLModelsSamples", package: "dl-models"),
				.product(name: "NetworkUtil", package: "network-util"),
				.product(name: "ILFormatters", package: "il-formatters"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
