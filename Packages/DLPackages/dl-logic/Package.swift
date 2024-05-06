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
		.package(
			path: "../../DLPackages/dl-models"
		),
		.package(
			path: "../dl-utils"
		),
		.package(
			url: "https://github.com/apple/swift-async-algorithms",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "DLLogic",
			dependencies: [
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLUtils", package: "dl-utils"),
				.product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
			]
		),
	]
)
