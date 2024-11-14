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
		.package(
			url: "https://github.com/AsioOtus/multitool",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "ILFormatters",
			dependencies: [
				.product(
					name: "DLModels",
					package: "dl-models"
				),

				.product(
					name: "Multitool",
					package: "multitool"
				),
			]
		),
		.testTarget(
			name: "ILFormattersTests",
			dependencies: [
				.target(
					name: "ILFormatters"
				),
				.product(
					name: "Multitool",
					package: "multitool"
				),
			]
		)
	]
)
