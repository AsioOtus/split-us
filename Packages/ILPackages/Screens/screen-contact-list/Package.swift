// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-contact-list",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenContactList",
			targets: [
				"ScreenContactList"
			]
		)
	],
	dependencies: [
		.package(path: "../screen-add-contacts"),
		.package(path: "../screen-user-profile"),
		.package(path: "../../il-debug"),
		.package(path: "../../il-components"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenContactList",
			dependencies: [
				.product(name: "ScreenAddContacts", package: "screen-add-contacts"),
				.product(name: "ScreenUserProfile", package: "screen-user-profile"),
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
