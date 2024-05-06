import DLUtils
import SwiftUI

public struct LoadableElementsView<
	Elements,
	InitialView,
	LoadingView,
	EmptyElementsView,
	ElementView,
	FailedView
>: View
where
Elements: RandomAccessCollection,
Elements.Element: Hashable,
InitialView: View,
LoadingView: View,
EmptyElementsView: View,
ElementView: View,
FailedView: View {
	public let collection: Loadable<Elements>
	
	public let initialView: () -> InitialView
	public let loadingView: () -> LoadingView
	public let emptyView: () -> EmptyElementsView
	public let elementView: (Elements.Element) -> ElementView
	public let failedView: (Error) -> FailedView
	
	public init (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { EmptyView() },
		@ViewBuilder elementView: @escaping (Elements.Element) -> ElementView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.collection = collection
		self.initialView = initialView
		self.loadingView = loadingView
		self.emptyView = emptyView
		self.elementView = elementView
		self.failedView = failedView
	}
	
	public var body: some View {
		switch collection {
		case .initial: initialView()
		case .processing(let loading): loadingView(loading)
		case .successful(let collection): successfulView(collection)
		case .failed(let error): failedView(error)
		}
	}
	
	@ViewBuilder
	func loadingView (_ loading: Loading<Elements>) -> some View {
		if let collection = loading.previousValue {
			successfulView(collection)
		} else {
			loadingView()
		}
	}
	
	@ViewBuilder
	func successfulView (_ collection: Elements) -> some View {
		if collection.isEmpty {
			successfulEmptyView()
		} else {
			successfulElementsView(collection)
		}
	}
	
	func successfulEmptyView () -> some View {
		emptyView()
	}
	
	func successfulElementsView (_ collection: Elements) -> some View {
		ForEach(collection, id: \.self) { element in
			elementView(element)
		}
	}
}

extension LoadableElementsView {
	public static func labeled (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Loadable collection – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Loadable collection – Loading") },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { LoadablePlaceholderView("Loadable collection – Empty") },
		@ViewBuilder elementView: @escaping (Elements.Element) -> ElementView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Loadable collection – Failed") }
	) -> Self {
		.init(
			collection: collection,
			initialView: initialView,
			loadingView: loadingView,
			emptyView: emptyView,
			elementView: elementView,
			failedView: failedView
		)
	}
}
