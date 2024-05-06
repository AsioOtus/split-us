// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "prototypes",
	platforms: [
		.iOS(.v17),
	],
	products: [
		.library(
			name: "Prototypes",
			targets: [
				"MapView"
			]
		)
	],
	dependencies: [
		.package(path: "../ILPackages/il-components"),
		.package(path: "../ILPackages/il-models"),
		.package(path: "../ILPackages/il-preview-models"),
		.package(path: "../ILPackages/il-formatters"),
		.package(path: "../ILPackages/il-localization"),
		.package(path: "../DLPackages/dl-services"),
		.package(path: "../utils"),
	],
	targets: [
		.target(
			name: "MapView",
			dependencies: [
				.product(
					name: "ILComponents",
					package: "il-components"
				),
				.product(
					name: "ILFormatters",
					package: "il-formatters"
				),
				.product(
					name: "ILModels",
					package: "il-models"
				),
				.product(
					name: "DLServices",
					package: "dl-services"
				),
				.product(
					name: "Utils",
					package: "utils"
				)
			]
		)
	]
)
