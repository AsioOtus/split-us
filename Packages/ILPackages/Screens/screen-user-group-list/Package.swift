// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-user-group-list",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenUserGroupList",
			targets: [
				"ScreenUserGroupList"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-debug"),
		.package(path: "../screen-user-group-details"),
		.package(path: "../screen-user-group-info"),
		.package(path: "../screen-user-group-creation"),
		.package(path: "../../il-components"),
		.package(path: "../../il-logic"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenUserGroupList",
			dependencies: [
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "ScreenUserGroupDetails", package: "screen-user-group-details"),
				.product(name: "ScreenUserGroupInfo", package: "screen-user-group-info"),
				.product(name: "ScreenUserGroupCreation", package: "screen-user-group-creation"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
