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
			name: "ILDesignSystem",
			targets: [
				"ILDesignComponents",
				"ILDesignResources",
			]
		)
	],
	targets: [
		.target(
			name: "ILDesignComponents"
		),
		.target(
			name: "ILDesignResources"
		),
	]
)
