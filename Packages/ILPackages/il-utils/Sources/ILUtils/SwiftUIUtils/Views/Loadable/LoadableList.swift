import DLUtils
import SwiftUI

public struct LoadableList<
	Elements,
	InitialView,
	LoadingView,
	EmptyElementsView,
	SuccessfulView,
	FailedView
>: View
where
Elements: RandomAccessCollection,
Elements.Element: Hashable,
InitialView: View,
LoadingView: View,
EmptyElementsView: View,
SuccessfulView: View,
FailedView: View {
	public let collection: Loadable<Elements>
	
	public let initialView: () -> InitialView
	public let loadingView: () -> LoadingView
	public let emptyView: () -> EmptyElementsView
	public let successfulView: (Elements) -> SuccessfulView
	public let failedView: (Error) -> FailedView
	
	public init (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { EmptyView() },
		@ViewBuilder successfulView: @escaping (Elements) -> SuccessfulView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.collection = collection
		self.initialView = initialView
		self.loadingView = loadingView
		self.emptyView = emptyView
		self.successfulView = successfulView
		self.failedView = failedView
	}
	
	public var body: some View {
		List {
			switch collection {
			case .initial: initialView()
			case .processing(let loading): loadingView(loading)
			case .successful(let collection) where !collection.isEmpty: successfulView(collection)
			case .successful: EmptyView()
			case .failed: EmptyView()
			}
		}
		.overlay {
			switch collection {
			case .initial: initialView()
			case .processing(let loading): loadingPlaceholderView(loading)
			case .successful(let collection) where collection.isEmpty: emptyView()
			case .successful: EmptyView()
			case .failed(let error): failedView(error)
			}
		}
	}
	
	@ViewBuilder
	func loadingView (_ loading: Loading<Elements>) -> some View {
		if let collection = loading.previousValue {
			successfulView(collection)
		}
	}
	
	@ViewBuilder
	func loadingPlaceholderView (_ loading: Loading<Elements>) -> some View {
		if let collection = loading.previousValue {
			if collection.isEmpty {
				emptyView()
			}
		} else {
			loadingView()
		}
	}
}

extension LoadableList {
	public static func labeled (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Loadable list – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Loadable list – Loading") },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { LoadablePlaceholderView("Loadable list – Empty") },
		@ViewBuilder successfulView: @escaping (Elements) -> SuccessfulView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Loadable list – Failed") }
	) -> Self {
		.init(
			collection: collection,
			initialView: initialView,
			loadingView: loadingView,
			emptyView: emptyView,
			successfulView: successfulView,
			failedView: failedView
		)
	}
}
