import SwiftUI

struct SelectionIndicatorView: View {
	let userSelectionState: SelectionState
	
	var body: some View {
		switch userSelectionState {
		case .unselected: unselectedView()
		case .selected: selectedSelectionView()
		case .locked: lockedSelectionView()
		}
	}
	
	func unselectedView () -> some View {
		Color.clear
	}
	
	func selectedSelectionView () -> some View {
		Color.blue.opacity(0.5)
	}
	
	func lockedSelectionView () -> some View {
		Stripes(
			config: .init(
				background: .blue.opacity(0.5),
				foreground: .blue.opacity(0.75),
				degrees: -45,
				barWidth: 5,
				barSpacing: 5
			)
		)
	}
}
