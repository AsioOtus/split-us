import ComposableArchitecture
import DLUtils
import SwiftUI

public struct ComposableLoadableView<Action, Value, InitialView, LoadingView, SuccessfulView, FailedView>: View
where
Action: CasePathable,
Value: Equatable,
InitialView: View,
LoadingView: View,
SuccessfulView: View,
FailedView: View
{
	public typealias LoadableValue = Loadable<Value>

	let store: Store<LoadableValue, Action>
	
	let initialView: () -> InitialView
	let loadingView: () -> LoadingView
	let successfulView: (Store<Value, Action>) -> SuccessfulView
	let failedView: (Error) -> FailedView

	public init (
		store: Store<LoadableValue, Action>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder successfulView: @escaping (Store<Value, Action>) -> SuccessfulView = { (_: Store<Value, Action>) in EmptyView() },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.store = store
		self.initialView = initialView
		self.loadingView = loadingView
		self.successfulView = successfulView
		self.failedView = failedView
	}
	
	public var body: some View {
		switch store.state {
		case .initial:
			initialView()

		case .processing:
			if let store = store.scope(state: \.processing, action: \.self) {
				loadingView(store)
			}

		case .successful:
			if let store = store.scope(state: \.successful, action: \.self) {
				successfulView(store)
			}

		case .failed(let error):
			failedView(error)
		}
	}

	@ViewBuilder
	private func loadingView (_ loadingStore: Store<Loading<Value>, Action>) -> some View {
		if let loadingValueStore = loadingStore.scope(state: \.previousValue, action: \.self) {
			successfulView(loadingValueStore)
		} else {
			loadingView()
		}
	}
}

extension ComposableLoadableView {
	static func labeled (
		store: Store<LoadableValue, Action>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Composable loadable – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Composable loadable – Loading") },
		@ViewBuilder successfulView: @escaping (Store<Value, Action>) -> SuccessfulView = { (_: Store<Value, Action>) in LoadablePlaceholderView("Composable loadable – Successful") },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Composable loadable – Failed") }
	) -> Self {
		.init(
			store: store,
			initialView: initialView,
			loadingView: loadingView,
			successfulView: successfulView,
			failedView: failedView
		)
	}
}
