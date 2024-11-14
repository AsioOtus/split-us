// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-models",
	platforms: [
		.iOS(.v17),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "ILModels",
			targets: [
				"ILModels",
			]
		),
		.library(
			name: "ILModelsMappers",
			targets: [
				"ILModelsMappers",
			]
		),
	],
	dependencies: [
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../il-formatters"),
	],
	targets: [
		.target(
			name: "ILModels",
			dependencies: [
				.product(
					name: "DLModels",
					package: "dl-models"
				),
			]
		),
		.target(
			name: "ILModelsMappers",
			dependencies: [
				.product(
					name: "DLModels",
					package: "dl-models"
				),
				.product(
					name: "ILFormatters",
					package: "il-formatters"
				),
				.target(
					name: "ILModels"
				),
			]
		),
	]
)
