// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-registration",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenRegistration",
			targets: [
				"ScreenRegistration"
			]
		)
	],
	dependencies: [
		.package(path: "../../../DLPackages/dl-services"),
		.package(path: "../../il-components"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenRegistration",
			dependencies: [
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
