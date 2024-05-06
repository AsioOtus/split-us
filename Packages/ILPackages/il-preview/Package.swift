// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-preview",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILPreview",
			targets: [
				"ILPreview"
			]
		),
		.library(
			name: "ILPreviewModels",
			targets: [
				"ILPreviewModels"
			]
		),
	],
	dependencies: [
		.package(path: "../il-models"),
	],
	targets: [
		.target(
			name: "ILPreview",
			dependencies: [
				.product(
					name: "ILModels",
					package: "il-models"
				),
			]
		),
		.target(
			name: "ILPreviewModels",
			dependencies: [
				.product(
					name: "ILModels",
					package: "il-models"
				),
			]
		),
	]
)
