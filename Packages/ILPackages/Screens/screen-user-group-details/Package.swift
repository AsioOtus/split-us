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
		.package(path: "../screen-summary"),
		.package(path: "../screen-user-group-info"),
		.package(path: "../screen-expense-editing"),
		.package(path: "../screen-expense-group-editing"),
		.package(path: "../../il-components-tca"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenUserGroupDetails",
			dependencies: [
				.product(name: "ILComponentsTCA", package: "il-components-tca"),
				.product(name: "ScreenUserGroupInfo", package: "screen-user-group-info"),
				.product(name: "ScreenSummary", package: "screen-summary"),
				.product(name: "ScreenExpenseEditing", package: "screen-expense-editing"),
				.product(name: "ScreenExpenseGroupEditing", package: "screen-expense-group-editing"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
