// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "dl-services",
	platforms: [
		.iOS(.v17),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "DLServices",
			targets: ["DLServices"]
		),
	],
	dependencies: [
		.package(
			path: "../dl-models"
		),
		.package(
			path: "../dl-network"
		),
		.package(
			path: "../dl-persistence"
		),
		.package(
			url: "https://github.com/pointfreeco/swift-dependencies",
			exact: "1.3.5"
		),
		.package(
			url: "https://github.com/auth0/JWTDecode.swift.git",
			exact: "3.1.0"
		),
		.package(
			url: "https://github.com/auth0/SimpleKeychain",
			exact: "1.1.0"
		),
		.package(
			url: "https://github.com/apple/swift-async-algorithms",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "DLServices",
			dependencies: [
				.product(
					name: "DLModels",
					package: "dl-models"
				),
				.product(
					name: "DLModelsSamples",
					package: "dl-models"
				),
				.product(
					name: "DLNetwork",
					package: "dl-network"
				),
				.product(
					name: "DLPersistence",
					package: "dl-persistence"
				),
				.product(
					name: "Dependencies",
					package: "swift-dependencies"
				),
				.product(
					name: "JWTDecode",
					package: "jwtdecode.swift"
				),
				.product(
					name: "SimpleKeychain",
					package: "SimpleKeychain"
				),
				.product(
					name: "AsyncAlgorithms",
					package: "swift-async-algorithms"
				),
			]
		),
	]
)
