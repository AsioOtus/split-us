import ComposableArchitecture
import DLModels
import ILComponents
import ILModels
import ILModelsMappers
import SwiftUI

extension SingleSelector {
	public struct ButtonView <SelectedItemView: View, ListItemView: View, PickerItemView: View>: View {
		let userScreenModelMapper = UserScreenModel.Mapper.default

		@Bindable var store: StoreOf<SingleSelector.Reducer>
		let selectedItemView: (Item) -> SelectedItemView
		let listItemView: (Item) -> ListItemView
		let pickerItemView: (Item) -> PickerItemView

		public init(
			store: StoreOf<SingleSelector.Reducer>,
			@ViewBuilder selectedItemView: @escaping (Item) -> SelectedItemView,
			@ViewBuilder listItemView: @escaping (Item) -> ListItemView,
			@ViewBuilder pickerItemView: @escaping (Item) -> PickerItemView
		) {
			self.store = store
			self.listItemView = listItemView
			self.pickerItemView = pickerItemView
			self.selectedItemView = selectedItemView
		}

		public var body: some View {
			contentView()
				.navigationDestination(isPresented: $store.isListPresented) {
					SingleSelector.ScreenList(store: store, itemView: listItemView)
				}
				.task {
					store.send(.pageLoading(.initialize))
				}
		}
	}
}

private extension SingleSelector.ButtonView {
	@ViewBuilder
	func contentView () -> some View {
		if store.mode == .picker {
			pickerButton()
		} else {
			listButton()
		}
	}

	func pickerButton () -> some View {
		Menu {
			SingleSelector.ScreenPicker(store: store, itemView: pickerItemView)
		} label: {
			buttonLabel()
		}
	}

	func listButton () -> some View {
		Button {
			store.send(.onListButtonTap)
		} label: {
			buttonLabel()
		}
	}

	@ViewBuilder
	func buttonLabel () -> some View {
		if let selectedItem = store.selectedItem {
			selectedItemView(selectedItem)
		} else {
			Text(.generalNotSelected)
		}
	}
}
