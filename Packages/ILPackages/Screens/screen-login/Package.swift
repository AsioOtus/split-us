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
		.package(path: "../../il-debug-tca"),
		.package(path: "../../../DLPackages/dl-services"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ScreenLogin",
			dependencies: [
				.product(name: "ILDebug", package: "il-debug"),
				.product(name: "ILDebugTCA", package: "il-debug-tca"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
