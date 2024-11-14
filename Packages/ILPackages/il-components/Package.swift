// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-components",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILComponents",
			targets: [
				"ILComponents",
			]
		)
	],
	dependencies: [
		.package(path: "../il-design-system"),
		.package(path: "../il-localization"),
		.package(path: "../il-formatters"),
		.package(path: "../il-models"),
		.package(path: "../il-preview"),
		.package(path: "../il-utils"),
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../../DLPackages/dl-logic"),
		.package(path: "../../DLPackages/dl-utils"),

			.package(
				url: "https://github.com/AsioOtus/multitool",
				from: "1.0.0"
			),
		.package(
			url: "https://github.com/AsioOtus/multitool-kit",
			from: "1.0.0"
		),
		.package(
			url: "https://github.com/elai950/AlertToast",
			exact: "1.3.9"
		),
	],
	targets: [
		.target(
			name: "ILComponents",
			dependencies: [
				.product(name: "AlertToast", package: "AlertToast"),
				.product(name: "CoreLocationUtils", package: "dl-utils"),
				.product(name: "DLLogic", package: "dl-logic"),
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLModelsSamples", package: "dl-models"),
				.product(name: "ILDesignSystem", package: "il-design-system"),
				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "ILFormatters", package: "il-formatters"),
				.product(name: "ILModels", package: "il-models"),
				.product(name: "ILModelsMappers", package: "il-models"),
				.product(name: "ILPreview", package: "il-preview"),
				.product(name: "ILPreviewModels", package: "il-preview"),
				.product(name: "ILUtils", package: "il-utils"),
				.product(name: "Multitool", package: "multitool"),
				.product(name: "MultitoolKitFluent", package: "multitool-kit"),
			]
		),
	]
)
