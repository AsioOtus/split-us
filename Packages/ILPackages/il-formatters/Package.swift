// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-formatters",
	platforms: [
		.iOS(.v16),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "ILFormatters",
			targets: [
				"ILFormatters"
			]
		)
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-models"),
	],
	targets: [
		.target(
			name: "ILFormatters",
			dependencies: [
				.product(
					name: "DLModels",
					package: "dl-models"
				),
			]
		)
	]
)
