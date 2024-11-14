// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-summary",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenSummary",
			targets: [
				"ScreenSummary"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-components"),
		.package(path: "../../il-components-tca"),
		.package(path: "../../il-utils-tca"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenSummary",
			dependencies: [
				.product(name: "ILUtilsTCA", package: "il-utils-tca"),
				.product(name: "ILComponentsTCA", package: "il-components-tca"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
