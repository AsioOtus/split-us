// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-logic",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "DLLogic",
			targets: [
				"DLLogic",
			]
		)
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../dl-utils"),
	],
	targets: [
		.target(
			name: "DLLogic",
			dependencies: [
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "SwiftUtils", package: "dl-utils"),
			]
		),
	]
)
