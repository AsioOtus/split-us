import ComponentsMap
import ComposableArchitecture
import DLLogic
import DLModels
import ILLocalization
import MapKit
import SwiftUI

extension TransferInfoEditing {
	public struct Screen: View {
		@State private var vm: TransferInfoEditing.ViewModel

		@Binding var name: String?
		@Binding var note: String?
		@Binding var date: Date?

		private var nameBinding: Binding<String> {
			$name.unwrap(default: "")
		}

		private var noteBinding: Binding<String> {
			$note
				.update(
					set: { vm.isNoteEnabled ? $0 : nil }
				)
				.unwrap(default: "")
		}

		private var dateBinding: Binding<Date> {
			$date.unwrap(default: .init())
		}

		private var coordinateBinding: Binding<Coordinate?> {
			.init(
				get: {
					nil
				},
				set: { _ in

				}
			)
		}

		public init (
			name: Binding<String?>,
			note: Binding<String?>,
			date: Binding<Date?>
		) {
			self._name = name
			self._note = note
			self._date = date

			self._vm = .init(initialValue: .init(selectedCoordinate: nil))
		}

		public var body: some View {
			Section {
				nameView()
				compactDateView()

				togglesView()

				if vm.isNoteEnabled {
					noteView()
				}

				if vm.isLocationEnabled {
					locationView()
				}
			}
		}
	}
}

// MARK: - Subviews
private extension TransferInfoEditing.Screen {
	func togglesView () -> some View {
		HStack {
			Spacer()
			Toggle("", systemImage: "note.text", isOn: $vm.isNoteEnabled.animation())
			Toggle("", systemImage: "location.fill", isOn: $vm.isLocationEnabled.animation())
			Spacer()
		}
		.listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
		.font(.system(size: 22))
		.toggleStyle(.button)
		.labelStyle(.iconOnly)
	}

	func nameView () -> some View {
		TextField(
			.transferInfoEditingViewTransferName,
			text: nameBinding
		)
	}

	func noteView () -> some View {
		TextField(
			.transferInfoEditingViewTransferNotes,
			text: noteBinding,
			axis: .vertical
		)
	}

	func compactDateView () -> some View {
		DatePicker(
			.generalDate,
			selection: dateBinding
		)
		.datePickerStyle(.compact)
	}

	func locationView () -> some View {
		ExpenseMap.Screen(store: vm.expenseMapStore)
			.contentShape(.rect)
			.frame(height: 150)
			.listRowInsets(.init())
			.onChange(of: vm.expenseMapStore.selectedCoordinate) {
				if let coordinate = vm.expenseMapStore.selectedCoordinate {
					coordinateBinding.wrappedValue = .init(clLocationCoordinate2d: coordinate)
				}
			}
			.onChange(of: vm.expenseMapStore.selectedTitle) {
				if name == nil || name == "" {
					name = vm.expenseMapStore.selectedTitle
				}
			}
	}
}
