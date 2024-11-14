import ComposableArchitecture
import Multitool

// MARK: - CasePathable macro
extension LoadableValue {
	public struct AllCasePaths {
		public var initial: CasePaths.AnyCasePath<LoadableValue, Void> {
			CasePaths.AnyCasePath<LoadableValue, Void>(
				embed: {
					LoadableValue.initial
				},
				extract: {
					guard case .initial = $0 else {
						return nil
					}
					return ()
				}
			)
		}
		public var loading: CasePaths.AnyCasePath<LoadableValue, (task: LoadingTask?, value: Value?)> {
			CasePaths.AnyCasePath<LoadableValue, (task: LoadingTask?, value: Value?)>(
				embed: LoadableValue.loading,
				extract: {
					guard case let .loading(v0, v1) = $0 else {
						return nil
					}
					return (v0, v1)
				}
			)
		}
		public var successful: CasePaths.AnyCasePath<LoadableValue, Value> {
			CasePaths.AnyCasePath<LoadableValue, Value>(
				embed: LoadableValue.successful,
				extract: {
					guard case let .successful(v0) = $0 else {
						return nil
					}
					return v0
				}
			)
		}
		public var failed: CasePaths.AnyCasePath<LoadableValue, (error: Failed, value: Value?)> {
			CasePaths.AnyCasePath<LoadableValue, (error: Failed, value: Value?)>(
				embed: LoadableValue.failed,
				extract: {
					guard case let .failed(v0, v1) = $0 else {
						return nil
					}
					return (v0, v1)
				}
			)
		}
	}
	public static var allCasePaths: AllCasePaths { AllCasePaths() }
}

extension LoadableValue: CasePaths.CasePathable {
}

// MARK: - ObservableState

extension LoadableValue {
	public var _$id: ComposableArchitecture.ObservableStateID {
		switch self {
		case .initial:
			return ObservableStateID()._$tag(0)
		case .loading:
			return ObservableStateID()._$tag(1)
		case let .successful(state):
			return ._$id(for: state)._$tag(2)
		case .failed:
			return ObservableStateID()._$tag(3)
		}
	}

	public mutating func _$willModify() {
		switch self {
		case .initial:
			break
		case .loading:
			break
		case var .successful(state):
			ComposableArchitecture._$willModify(&state)
			self = .successful(state)
		case .failed:
			break
		}
	}
}

extension LoadableValue: ComposableArchitecture.ObservableState, Observation.Observable {
}
