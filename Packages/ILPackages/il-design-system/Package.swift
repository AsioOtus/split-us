// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-design-system",
	platforms: [
		.iOS(.v16),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "DesignSystem",
			targets: [
				"DesignComponents",
				"DesignResources",
			]
		)
	],
	targets: [
		.target(
			name: "DesignComponents"
		),
		.target(
			name: "DesignResources"
		),
	]
)
