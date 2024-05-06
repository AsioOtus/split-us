// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-transfer-group-editing",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenTransferGroupEditing",
			targets: [
				"ScreenTransferGroupEditing"
			]
		)
	],
	dependencies: [
		.package(path: "../screen-transfer-editing"),
		.package(path: "../../il-components"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenTransferGroupEditing",
			dependencies: [
				.product(name: "ScreenTransferEditing", package: "screen-transfer-editing"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
