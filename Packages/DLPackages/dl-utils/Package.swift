// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-utils",
	platforms: [
		.iOS(.v17),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "CombineUtils",
			targets: [
				"CombineUtils",
			]
		),
		.library(
			name: "CoreLocationUtils",
			targets: [
				"CoreLocationUtils",
			]
		),
		.library(
			name: "SwiftUtils",
			targets: [
				"SwiftUtils",
			]
		),
	],
	targets: [
		.target(name: "CombineUtils"),
		.target(name: "CoreLocationUtils"),
		.target(name: "SwiftUtils"),
	]
)
