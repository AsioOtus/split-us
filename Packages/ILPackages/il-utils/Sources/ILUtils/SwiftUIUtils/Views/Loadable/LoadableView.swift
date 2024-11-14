import Multitool
import SwiftUI

public struct LoadableView<
	Value,
	InitialView,
	LoadingView,
	SuccessfulView,
	FailedView
>: View
where
InitialView: View,
LoadingView: View,
SuccessfulView: View,
FailedView: View {
	public let value: Loadable<Value>

	public let initialView: () -> InitialView
	public let loadingView: () -> LoadingView
	public let successfulView: (Value) -> SuccessfulView
	public let failedView: (Error) -> FailedView

	public init (
		value: Loadable<Value>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder successfulView: @escaping (Value) -> SuccessfulView = { (_: Value) in EmptyView() },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.value = value
		self.initialView = initialView
		self.loadingView = loadingView
		self.successfulView = successfulView
		self.failedView = failedView
	}

	public var body: some View {
		switch value {
		case .initial: initialView()
		case .loading(_, let value): loadingView(value)
		case .successful(let value): successfulView(value)
		case .failed(let error, _): failedView(error)
		}
	}

	@ViewBuilder
	func loadingView (_ value: Value?) -> some View {
		if let value {
			successfulView(value)
		} else {
			loadingView()
		}
	}
}

extension LoadableView {
	public static func labeled (
		value: Loadable<Value>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Loadable – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Loadable – Loading") },
		@ViewBuilder successfulView: @escaping (Value) -> SuccessfulView = { (_: Value) in LoadablePlaceholderView("Loadable – Successful") },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Loadable – Failed") }
	) -> Self {
		.init(
			value: value,
			initialView: initialView,
			loadingView: loadingView,
			successfulView: successfulView,
			failedView: failedView
		)
	}
}
