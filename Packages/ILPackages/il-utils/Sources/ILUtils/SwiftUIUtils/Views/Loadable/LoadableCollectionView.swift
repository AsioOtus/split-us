import DLUtils
import SwiftUI

public struct LoadableCollectionView<
	Elements,
	InitialView,
	LoadingView,
	EmptyElementsView,
	CollectionView,
	FailedView
>: View
where
Elements: RandomAccessCollection,
InitialView: View,
LoadingView: View,
EmptyElementsView: View,
CollectionView: View,
FailedView: View {
	public let collection: Loadable<Elements>
	
	public let initialView: () -> InitialView
	public let loadingView: () -> LoadingView
	public let emptyView: () -> EmptyElementsView
	public let collectionView: (Elements) -> CollectionView
	public let failedView: (Error) -> FailedView
	
	public init (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { EmptyView() },
		@ViewBuilder collectionView: @escaping (Elements) -> CollectionView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.collection = collection
		self.initialView = initialView
		self.loadingView = loadingView
		self.emptyView = emptyView
		self.collectionView = collectionView
		self.failedView = failedView
	}
	
	public var body: some View {
		switch collection {
		case .initial: initialView()
		case .processing(let loading): loadingView(loading)
		case .successful(let collection) where collection.isEmpty: emptyView()
		case .successful(let collection): collectionView(collection)
		case .failed(let error): failedView(error)
		}
	}
	
	@ViewBuilder
	func loadingView (_ loading: Loading<Elements>) -> some View {
		if let collection = loading.previousValue {
			collectionView(collection)
		} else {
			loadingView()
		}
	}
}

extension LoadableCollectionView {
	public static func labeled (
		collection: Loadable<Elements>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Loadable collection – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Loadable collection – Loading") },
		@ViewBuilder emptyView: @escaping () -> EmptyElementsView = { LoadablePlaceholderView("Loadable collection – Empty") },
		@ViewBuilder collectionView: @escaping (Elements) -> CollectionView,
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Loadable collection – Failed") }
	) -> Self {
		.init(
			collection: collection,
			initialView: initialView,
			loadingView: loadingView,
			emptyView: emptyView,
			collectionView: collectionView,
			failedView: failedView
		)
	}
}
