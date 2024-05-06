import SwiftUI
import DLUtils

public struct LoadableButton<Value>: View {
	let label: LocalizedStringKey
	let loadable: Loadable<Value>
	let action: () -> Void
	
	public init (
		label: LocalizedStringKey,
		loadable: Loadable<Value>,
		action: @escaping () -> Void
	) {
		self.label = label
		self.loadable = loadable
		self.action = action
	}
	
	public var body: some View {
		if loadable.isLoading {
			ProgressView()
		} else {
			Button(label) {
				action()
			}
		}
	}
}
