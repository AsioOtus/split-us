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
				"ILComponentsViewModifiers",
				"ComponentsMap",
				"AmountComponents",
				"ButtonComponents",
				"KeyboardComponents",
				"HintListComponent",
				"TextFieldComponents",
				"TransferComponents",
				"UnavailablePlaceholderComponents",
				"UserComponents",
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
		.package(path: "../../DLPackages/dl-services"),
		.package(path: "../../DLPackages/dl-utils"),

		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			exact: "1.8.0"
		),
		.package(
			url: "https://github.com/AsioOtus/multitool",
			from: "1.0.0"
		),
		.package(
			url: "https://github.com/AsioOtus/multitool-kit",
			from: "1.0.0"
		),
	],
	targets: [
		.target(
			name: "ILComponentsViewModifiers"
		),
		.target(
			name: "AmountComponents",
			dependencies: [
				.target(name: "ButtonComponents"),
				.target(name: "UserComponents"),
				.target(name: "TextFieldComponents"),
				.product(name: "DesignSystem", package: "il-design-system"),
				.product(name: "DLModels", package: "dl-models"),
				.product(name: "DLLogic", package: "dl-logic"),
				.product(name: "ILPreview", package: "il-preview"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.target(
			name: "ButtonComponents",
			dependencies: [
				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "DLUtils", package: "dl-utils"),
			]
		),
		.target(
			name: "KeyboardComponents",
			dependencies: [
				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "ILUtils", package: "il-utils"),
			]
		),
		.target(
			name: "HintListComponent",
			dependencies: [
				.product(name: "ILLocalization", package: "il-localization")
			]
		),
		.target(
			name: "TextFieldComponents"
		),
		.target(
			name: "TransferComponents",
			dependencies: [
				.target(name: "AmountComponents"),
				.target(name: "UserComponents"),
				.target(name: "ComponentsMap"),

				.product(name: "ILModels", package: "il-models"),
				.product(name: "ILModelsMappers", package: "il-models"),
				.product(name: "DLModels", package: "dl-models"),

				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.target(
			name: "UnavailablePlaceholderComponents",
			dependencies: [
				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "ILUtils", package: "il-utils"),
				.product(name: "ILPreview", package: "il-preview"),
			]
		),
		.target(
			name: "UserComponents",
			dependencies: [
				"UnavailablePlaceholderComponents",
				.product(name: "DLUtils", package: "dl-utils"),
				.product(name: "ILFormatters", package: "il-formatters"),
				.product(name: "ILModels", package: "il-models"),
				.product(name: "ILModelsMappers", package: "il-models"),
				.product(name: "ILUtils", package: "il-utils"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.target(
			name: "ComponentsMap",
			dependencies: [
				.target(name: "UnavailablePlaceholderComponents"),

				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "DLUtils", package: "dl-utils"),

				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/Map"
		),
		.testTarget(
			name: "TestAmountComponents",
			dependencies: [
				.target(name: "AmountComponents"),
				.product(name: "DLModelsSamples", package: "dl-models"),
				.product(name: "Multitool", package: "multitool"),
				.product(name: "MultitoolKitFluent", package: "multitool-kit"),
			]
		),
	]
)
