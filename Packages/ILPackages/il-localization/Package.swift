// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-localization",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v16),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "ILLocalization",
			targets: ["ILLocalization"]
		)
	],
	targets: [
		.target(
			name: "ILLocalization"
		),
	]
)
