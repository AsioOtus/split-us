import ComponentsTCAMap
import ComposableArchitecture
import DLLogic
import DLModels
import ILLocalization
import MapKit
import SwiftUI

extension ExpenseInfoEditing {
	public struct Screen: View {
		@Bindable var store: StoreOf<Reducer>

		var dateTimeDisplayedComponents: DatePickerComponents {
			store.isEnabled.date
				? store.isEnabled.time
					? [.date, .hourAndMinute]
					: [.date]
				: []
		}

		public init (store: StoreOf<Reducer>) {
			self.store = store
		}

		public var body: some View {
			Section {
				nameView()
			}

			Section {
				togglesView()

				if store.isEnabled.date {
					dateView()
				}

				if store.isEnabled.note {
					noteView()
				}

				if store.isEnabled.coordinate {
					locationView()
				}
			}
		}
	}
}

// MARK: - Subviews
private extension ExpenseInfoEditing.Screen {
	func togglesView () -> some View {
		HStack {
			Toggle("", systemImage: "calendar", isOn: $store.isEnabled.date.animation())
			Toggle("", systemImage: "note.text", isOn: $store.isEnabled.note.animation())
			Toggle("", systemImage: "location.fill", isOn: $store.isEnabled.coordinate.animation())
		}
		.toggleStyle(.button)
		.labelStyle(.iconOnly)
		.frame(maxWidth: .infinity, alignment: .center)
		.listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
		.font(.system(size: 22))
	}

	func nameView () -> some View {
		TextField(
			.expenseInfoEditingViewExpenseName,
			text: $store.expenseInfo.name.unwrap(default: "")
		)
	}

	func dateView () -> some View {
		HStack {
			DatePicker(
				.generalDate,
				selection: $store.expenseInfo.date.unwrap(default: .init()),
				displayedComponents: dateTimeDisplayedComponents
			)
			.datePickerStyle(.compact)
			.labelsHidden()

			Toggle("", systemImage: "clock", isOn: $store.isEnabled.time.animation())
				.toggleStyle(.button)
				.labelStyle(.iconOnly)
		}
	}

	func noteView () -> some View {
		TextField(
			.expenseInfoEditingViewExpenseNotes,
			text: $store.expenseInfo.note.unwrap(default: ""),
			axis: .vertical
		)
	}

	func locationView () -> some View {
		ExpenseMap.Screen(
			store: store.scope(
				state: \.expenseMap,
				action: \.expenseMap
			)
		)
		.contentShape(.rect)
		.frame(height: 150)
		.listRowInsets(.init())
	}
}
