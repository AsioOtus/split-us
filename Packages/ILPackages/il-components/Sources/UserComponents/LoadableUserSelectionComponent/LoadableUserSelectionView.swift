import DLModels
import DLUtils
import ILModels
import ILUtils
import SwiftUI
import UnavailablePlaceholderComponents

public struct LoadableUserSelectionView: View {
	let label: LocalizedStringKey
	let users: Loadable<[User.Compact?]>
	@Binding var creditor: User.Compact?
	
	public init (
		label: LocalizedStringKey,
		users: Loadable<[User.Compact?]>,
		creditor: Binding<User.Compact?>
	) {
		self.label = label
		self.users = users
		self._creditor = creditor
	}
	
	public var body: some View {
		HStack {
			Text(label)
			
			Spacer()
			
			LoadableView(
				value: users,
				loadingView: loadingView,
				successfulView: successfulView,
				failedView: failedView
			)
		}
	}
}

private extension LoadableUserSelectionView {
	func loadingView () -> some View {
		StandardLoadingView()
	}
	
	func successfulView (_ users: [User.Compact?]) -> some View {
		UserSelectionPicker(
			users: users,
			selectedUser: $creditor
		)
	}
	
	func failedView (_ error: Error) -> some View {
		StandardErrorView()
			.controlSize(.mini)
	}
}
