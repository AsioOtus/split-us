// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-user-group-info",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenUserGroupInfo",
			targets: [
				"ScreenUserGroupInfo"
			]
		)
	],
	dependencies: [
		.package(path: "../screen-user-group-user-adding"),
		.package(path: "../screen-user-group-editing"),
		.package(path: "../screen-user-profile"),
		.package(path: "../../il-debug"),
		.package(path: "../../il-components"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenUserGroupInfo",
			dependencies: [
				.product(name: "ScreenUserGroupUserAdding", package: "screen-user-group-user-adding"),
				.product(name: "ScreenUserGroupEditing", package: "screen-user-group-editing"),
				.product(name: "ScreenUserProfile", package: "screen-user-profile"),
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
