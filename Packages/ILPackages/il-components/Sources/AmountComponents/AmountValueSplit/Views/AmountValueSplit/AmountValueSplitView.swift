import ButtonComponents
import DLModels
import DLLogic
import ILFormatters
import ILLocalization
import SwiftUI
import TextFieldComponents
import DLUtils

public struct AmountValueSplitView: View {
	@EnvironmentObject private var interactor: AmountValueSplitInteractor
	let vm: AmountValueSplitViewModel

	public init (
		vm: AmountValueSplitViewModel
	) {
		self.vm = vm
	}

	public var body: some View {
		Section {
			settingsView()
			amountView()
			usersView()
			settingsView()
		}
		.textFieldStyle(.bordered)
	}
}

private extension AmountValueSplitView {
	func usersView () -> some View {
		ForEach(vm.users, id: \.id) { user in
			UserSplitRowView(vm: .init(interactor: vm.interactor, user: user))
		}
	}

	func settingsView () -> some View {
		HStack {
			modePickerView()
			Spacer()
			selectionToggleView()
		}
		.toggleStyle(.button)
		.labelStyle(.iconOnly)
	}

	func selectionToggleView () -> some View {
		Toggle(
			"",
			systemImage: "checklist.checked",
			isOn: vm.isAllUsersSelectedOrLockedBinding
		)
	}

	func amountView () -> some View {
		HStack {
			splitValueSumView()

			Spacer()

			AmountView(NumberFormatter.currency.format(vm.usersAmountValue.double(0.01)) ?? "--")
				.amountViewAppearance(vm.usersAmountValue > vm.totalAmountValue ? .negative : .neutral)
		}
		.listRowInsets(.init())
		.padding(8)
	}

	func modePickerView () -> some View {
		Picker("", selection: vm.splitModeBinding) {
			ForEach(vm.allowedSplitModes, id: \.self) {
				Label("", systemImage: SplitModeSymbolFormatter.default.symbolName($0))
			}
		}
		.pickerStyle(.segmented)
	}

	@ViewBuilder
	func splitValueSumView () -> some View {
		switch vm.splitMode {
		case .exact:
			exactSumView()
		case .percent:
			percentSumView()
		case .parts:
			partCountSumView()
		}
	}

	func exactSumView () -> some View {
		Text(vm.usersSplitValue.doubleExactValue, format: .currency(code: "usd"))
	}

	func percentSumView () -> some View {
		Text(vm.usersSplitValue.doublePercentValue, format: .percent)
	}

	func partCountSumView () -> some View {
		HStack(spacing: 0) {
			Text(vm.usersSplitValue.description)
			Text("/")
			TextField(
				"",
				value: vm.partsCountBinding,
				format: .number,
				prompt: Text(vm.partCount.description)
			)
			.fixedSize()
			.keyboardType(.numberPad)

			if vm.partsCountBinding.wrappedValue != nil || vm.partsCountBinding.wrappedValue == 0 {
				Button {
					vm.partsCountBinding.wrappedValue = nil
				} label: {
					Image(systemName: "multiply.circle.fill")
						.foregroundStyle(.gray.secondary)
				}
				.padding(.leading, 4)
			}
		}
	}
}
