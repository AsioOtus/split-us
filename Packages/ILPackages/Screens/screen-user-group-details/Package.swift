// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-user-group-details",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenUserGroupDetails",
			targets: [
				"ScreenUserGroupDetails"
			]
		)
	],
	dependencies: [
		.package(path: "../screen-transfer-list"),
		.package(path: "../screen-summary"),
		.package(path: "../screen-user-group-info"),
		.package(path: "../../il-debug"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenUserGroupDetails",
			dependencies: [
				.product(name: "ScreenTransferList", package: "screen-transfer-list"),
				.product(name: "ScreenUserGroupInfo", package: "screen-user-group-info"),
				.product(name: "ScreenSummary", package: "screen-summary"),
				.product(name: "Debug", package: "il-debug"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
