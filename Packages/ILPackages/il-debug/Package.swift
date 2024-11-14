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
			name: "ILDebug",
			targets: [
				"ILDebug"
			]
		)
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-network"),
		.package(path: "../../DLPackages/dl-services"),
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../il-formatters"),
		.package(path: "../il-logic"),
		.package(url: "https://github.com/AsioOtus/network-util", from: "2.0.0"),
	],
	targets: [
		.target(
			name: "ILDebug",
			dependencies: [
				.product(name: "DLNetwork", package: "dl-network"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLModelsSamples", package: "dl-models"),
				.product(name: "NetworkUtil", package: "network-util"),
				.product(name: "ILFormatters", package: "il-formatters"),
				.product(name: "ILLogic", package: "il-logic"),
			]
		)
	]
)
