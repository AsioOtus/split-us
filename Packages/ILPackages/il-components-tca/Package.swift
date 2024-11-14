// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "il-components-tca",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "ILComponentsTCA",
			targets: [
				"ComponentsTCAExpense",
				"ComponentsTCAGeneral",
				"ComponentsTCAMap",
				"ComponentsTCAUser",
			]
		)
	],
	dependencies: [
		.package(path: "../il-components"),
		.package(path: "../il-localization"),
		.package(path: "../il-models"),
		.package(path: "../il-utils-tca"),
		.package(path: "../../DLPackages/dl-models"),
		.package(path: "../../DLPackages/dl-services"),
		.package(path: "../../DLPackages/dl-utils"),

		.package(
			url: "https://github.com/asiootus/ui-extensions",
			from: "1.0.0"
		),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
	],
	targets: [
		.target(
			name: "ComponentsTCAExpense",
			dependencies: [
				.target(name: "ComponentsTCAMap"),

				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILUtilsTCA", package: "il-utils-tca"),
				.product(name: "CoreLocationUtils", package: "dl-utils"),

				.product(name: "SwiftUIExtensions", package: "ui-extensions"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/Expense"
		),
		.target(
			name: "ComponentsTCAMap",
			dependencies: [
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ILLocalization", package: "il-localization"),
				.product(name: "CoreLocationUtils", package: "dl-utils"),

				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/Map"
		),
		.target(
			name: "ComponentsTCAGeneral",
			dependencies: [
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "DLServices", package: "dl-services"),
				.product(name: "ILLocalization", package: "il-localization"),

				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/General"
		),
		.target(
			name: "ComponentsTCAUser",
			dependencies: [
				.target(name: "ComponentsTCAGeneral"),

				.product(name: "DLModels", package: "dl-models"),
				.product(name: "ILComponents", package: "il-components"),
				.product(name: "ILModels", package: "il-models"),
				.product(name: "ILModelsMappers", package: "il-models"),

				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/User"
		),
	]
)
