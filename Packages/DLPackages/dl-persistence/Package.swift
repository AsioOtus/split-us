// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-persistence",
	platforms: [
		.iOS(.v15),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "DLPersistence",
			targets: ["DLPersistence"]
		),
	],
	dependencies: [
		.package(path: "../dl-models"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.3.5"),
	],
	targets: [
		.target(
			name: "DLPersistence",
			dependencies: [
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLModelsSamples", package: "dl-models"),
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
	]
)
