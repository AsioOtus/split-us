// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "screen-login",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ScreenLogin",
			targets: [
				"ScreenLogin"
			]
		)
	],
	dependencies: [
		.package(path: "../../il-debug"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.0"),
	],
	targets: [
		.target(
			name: "ScreenLogin",
			dependencies: [
				.product(name: "Debug", package: "il-debug"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
