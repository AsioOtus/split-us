// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-transfer-editing",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenTransferEditing",
			targets: [
				"ScreenTransferEditing"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-components"),
		.package(path: "../../il-logic"),
		.package(path: "../../il-debug"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenTransferEditing",
			dependencies: [
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "Debug", package: "il-debug"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "TestsScreenTransferEditing",
			dependencies: [
				.target(name: "ScreenTransferEditing"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "DLServices", package: "dl-services"),
			]
		)
	]
)
