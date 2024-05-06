import DLModels
import ILFormatters
import SwiftUI
import ILModels
import ILPreview
import UserComponents

struct UserSplitRowView: View {
	@State private var fillerContainerSize: CGSize?
	
	@EnvironmentObject private var interactor: AmountValueSplitInteractor
	let vm: UserSplitRowViewModel
	
	var sliderColor: Color {
		return switch vm.user.selectionState {
		case .unselected: .clear
		case .selected: .blue.opacity(0.18)
		case .locked: .blue.opacity(0.4)
		}
	}
	
	var sliderBorderColor: Color {
		return switch vm.user.selectionState {
		case .unselected: .clear
		case .selected: .blue.opacity(0.28)
		case .locked: .blue.opacity(0.5)
		}
	}
	
	var unselectedTextColor: Color {
		vm.user.selectionState.isUnselected
		? Color.gray
		: Color.black
	}
	
	var body: some View {
		HStack(spacing: 0) {
			leadingView()
			
			Spacer(minLength: 0)
			Divider()
			
			trailingView()
		}
		.listRowInsets(.init())
	}
}

private extension UserSplitRowView {
	func leadingView () -> some View {
		ZStack(alignment: .leading) {
			gestureView()
			leadingContentView()
		}
	}
	
	func gestureView () -> some View {
		Color.clear
			.size($fillerContainerSize)
			.contentShape(.rect)
			.gestureControl(
				onSelectionToggle: {
					withAnimation {
						vm.onUserSelectionToggle()
					}
				},
				onLockToggle: {
					withAnimation {
						vm.onUserLockToggle()
					}
				},
				onValueChanged: { percent in
					vm.onSliderChanged(percentDifference: percent)
				},
				onValueChangingCompleted: {
					vm.onSliderChangingCompleted()
				}
			)
			.background {
				sliderView()
			}
	}
	
	func leadingContentView () -> some View {
		VStack(alignment: .leading, spacing: 4) {
			userView()
			amountValueInputField()
			//			debugInfoView()
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.padding(.leading, vm.user.selectionState.isSelectedOrLocked ? vm.selectionIndicatorWidth : 0)
	}
	
	func userView () -> some View {
		UserNameUsernameView(
			name: vm.user.user.name,
			surname: vm.user.user.surname,
			username: vm.user.user.username
		)
		.foregroundStyle(unselectedTextColor)
	}
	
	func amountValueInputField () -> some View {
		Group {
			switch vm.splitMode {
			case .exact:
				currencyInputField()
			case .percent:
				percentInputField()
			case .parts:
				fractionInputField()
			}
		}
		.multilineTextAlignment(.leading)
		.fixedSize()
	}
	
	func numberInputField () -> some View {
		TextField(
			"",
			value: vm.userAmountExactValueBinding,
			format: .number
		)
		.keyboardType(.decimalPad)
	}
	
	func percentInputField () -> some View {
		TextField(
			"",
			value: vm.userAmountPercentValueBinding,
			format: .percent
		)
		.keyboardType(.decimalPad)
	}
	
	func currencyInputField () -> some View {
		TextField(
			"",
			value: vm.userAmountExactValueBinding,
			format: .currency(code: "usd")
		)
		.keyboardType(.decimalPad)
	}
	
	func fractionInputField () -> some View {
		HStack(spacing: 0) {
			TextField(
				"",
				value: vm.userAmountPartsValueBinding,
				format: .number
			)
			.keyboardType(.numberPad)
			
			Text("/\(vm.partCount)")
		}
	}
}

private extension UserSplitRowView {
	func sliderView () -> some View {
		HStack(spacing: 0) {
			selectionStateIndicatorView()
			percentFillerView()
		}
	}
	
	func selectionStateIndicatorView () -> some View {
		SelectionIndicatorView(userSelectionState: vm.user.selectionState)
			.frame(width: vm.selectionIndicatorWidth)
	}
	
	func percentFillerView () -> some View {
		ZStack(alignment: .leading) {
			Color.clear
			
			ZStack(alignment: .trailing) {
				sliderColor
				
				sliderBorderColor
					.opacity(0.5)
					.frame(width: 1)
			}
			.frame(width: vm.fillerWidth(fillerContainerSize: fillerContainerSize))
			.frame(maxHeight: .infinity)
			
			//			debugSliderMarkerView()
		}
	}
}

private extension UserSplitRowView {
	func trailingView () -> some View {
		VStack(spacing: 0) {
			amountView()
				.padding(4)
			
			Divider()
			
			stepperView()
		}
		.frame(minWidth: 100)
		.fixedSize(horizontal: true, vertical: false)
	}
	
	func amountView () -> some View {
		AmountView(vm.userAmountValueFormatted)
			.disabled(vm.user.selectionState.isUnselected)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	func stepperView () -> some View {
		StepperView(
			onIncrement: {
				withAnimation {
					vm.onIncrement()
				}
			},
			onDecrement: {
				withAnimation {
					vm.onDecrement()
				}
			}
		)
	}
}

private extension UserSplitRowView {
	func debugInfoView () -> some View {
		VStack(alignment: .leading) {
			Text("Amount " + vm.user.amountValue.description)
			Text("Split " + vm.user.splitValue.description)
			Text("Precise " + vm.user.sliderValue.description)
		}
		.font(.caption2)
	}
	
	func debugSliderMarkerView () -> some View {
		ZStack(alignment: .trailing) {
			Color.clear
			Color.gray
				.frame(width: 1)
		}
		.frame(width: vm.preciseFillerWidth(fillerContainerSize: fillerContainerSize))
		.frame(maxHeight: .infinity)
	}
}
