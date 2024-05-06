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
			]
		)
	],
	targets: [
		.target(
			name: "ILExtensions"
		),
	]
)
