// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-user-group-editing",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenUserGroupEditing",
			targets: [
				"ScreenUserGroupEditing"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-debug"),
		.package(path: "../../il-components"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenUserGroupEditing",
			dependencies: [
				.product(name: "Debug", package: "il-debug"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
