// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-debug",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "Debug",
			targets: [
				"Debug"
			]
		)
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-network"),
		.package(path: "../../DLPackages/dl-services"),
		.package(path: "../../DLPackages/dl-utils"),
		.package(path: "../il-formatters"),
		.package(path: "../il-logic"),
		.package(url: "https://github.com/AsioOtus/network-util", from: "1.0.0"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.0"),
	],
	targets: [
		.target(
			name: "Debug",
			dependencies: [
				.product(name: "DLNetwork", package: "dl-network"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "NetworkUtil", package: "network-util"),
				.product(name: "DLUtils", package: "dl-utils"),
				.product(name: "ILFormatters", package: "il-formatters"),
				.product(name: "ILLogic", package: "il-logic"),
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		)
	]
)
