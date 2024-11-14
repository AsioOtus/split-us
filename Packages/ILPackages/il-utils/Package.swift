// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-utils",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILUtils",
			targets: [
				"ILUtils",
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
			name: "ILUtils",
			dependencies: [
				.product(
					name: "Multitool",
					package: "multitool"
				),
			]
		),
	]
)
