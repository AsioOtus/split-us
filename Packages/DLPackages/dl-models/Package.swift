// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-models",
	platforms: [
		.iOS(.v13),
		.macOS(.v13),
	],
	products: [
		.library(
			name: "DLModels",
			targets: [
				"DLModels",
				"DLErrors",
			]
		),
		.library(
			name: "DLModelsSamples",
			targets: [
				"DLModelsSamples",
			]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/AsioOtus/multitool",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "DLModels",
			dependencies: [
				.product(name: "Multitool", package: "multitool"),
			]
		),
		.target(
			name: "DLErrors"
		),
		.target(
			name: "DLModelsSamples",
			dependencies: [
				.target(name: "DLModels"),
				.product(name: "Multitool", package: "multitool"),
			]
		),
	]
)
