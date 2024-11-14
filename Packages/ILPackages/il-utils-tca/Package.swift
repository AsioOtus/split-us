// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-utils-tca",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILUtilsTCA",
			targets: [
				"ILUtilsTCA",
			]
		)
	],
	dependencies: [
		.package(path: "../il-utils"),
		.package(url: "https://github.com/AsioOtus/multitool", from: "1.0.0"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ILUtilsTCA",
			dependencies: [
				.product(name: "ILUtils", package: "il-utils"),
				.product(name: "Multitool", package: "multitool"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
	]
)
