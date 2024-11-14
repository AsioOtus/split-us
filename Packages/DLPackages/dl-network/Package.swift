// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "dl-network",
	platforms: [
		.iOS(.v13),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "DLNetwork",
			targets: ["DLNetwork"]
		),
	],
	dependencies: [
		.package(
			path: "../../DLPackages/dl-models"
		),
		.package(
			url: "https://github.com/AsioOtus/network-util",
			from: "2.0.0"
		),
	],
	targets: [
		.target(
			name: "DLNetwork",
			dependencies: [
				.product(name: "DLModels", package: "dl-models"),

				.product(
					name: "NetworkUtil",
					package: "network-util"
				),
			]
		)
	]
)
