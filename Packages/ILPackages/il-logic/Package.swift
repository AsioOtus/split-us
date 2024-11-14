// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-logic",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILLogic",
			targets: [
				"ILExtensions",
				"ILLogic",
			]
		)
	],
	dependencies: [
		.package(path: "../il-utils"),
	],
	targets: [
		.target(
			name: "ILExtensions"
		),
		.target(
			name: "ILLogic",
			dependencies: [
				.product(name: "ILUtils", package: "il-utils"),
			]
		),
	]
)
