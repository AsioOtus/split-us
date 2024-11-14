import Multitool
import SwiftUI

public struct LoadableOptionalView<
	Value,
	InitialView,
	LoadingView,
	SomeView,
	NoneView,
	FailedView
>: View
where
InitialView: View,
LoadingView: View,
SomeView: View,
NoneView: View,
FailedView: View {
	public let value: Loadable<Value?>
	
	public let initialView: () -> InitialView
	public let loadingView: () -> LoadingView
	public let someView: (Value) -> SomeView
	public let noneView: () -> NoneView
	public let failedView: (Error) -> FailedView
	
	public init (
		value: Loadable<Value?>,
		@ViewBuilder initialView: @escaping () -> InitialView = { EmptyView() },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { EmptyView() },
		@ViewBuilder someView: @escaping (Value) -> SomeView = { (_: Value) in EmptyView() },
		@ViewBuilder noneView: @escaping () -> NoneView = { EmptyView() },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in EmptyView() }
	) {
		self.value = value
		self.initialView = initialView
		self.loadingView = loadingView
		self.someView = someView
		self.noneView = noneView
		self.failedView = failedView
	}
	
	public var body: some View {
		switch value {
		case .initial: initialView()
		case .loading: loadingView()
		case .successful(let value): successfulView(value)
		case .failed(let error, _): failedView(error)
		}
	}
	
	@ViewBuilder
	func successfulView (_ value: Value?) -> some View {
		if let value {
			someView(value)
		} else {
			noneView()
		}
	}
}

extension LoadableOptionalView {
	public static func labeled (
		value: Loadable<Value?>,
		@ViewBuilder initialView: @escaping () -> InitialView = { LoadablePlaceholderView("Loadable optional – Initial") },
		@ViewBuilder loadingView: @escaping () -> LoadingView = { LoadablePlaceholderView("Loadable optional – Loading") },
		@ViewBuilder someView: @escaping (Value) -> SomeView = { (_: Value) in LoadablePlaceholderView("Loadable optional – Some") },
		@ViewBuilder noneView: @escaping () -> NoneView = { LoadablePlaceholderView("Loadable optional – None") },
		@ViewBuilder failedView: @escaping (Error) -> FailedView = { _ in LoadablePlaceholderView("Loadable optional – Failed") }
	) -> Self {
		.init(
			value: value,
			initialView: initialView,
			loadingView: loadingView,
			someView: someView,
			noneView: noneView,
			failedView: failedView
		)
	}
}
