import ComposableArchitecture
import ComponentsMap
import DLLogic
import DLModels
import MapKit
import SwiftUI

extension TransferInfoEditing {
	public struct ViewModel {
		let expenseMapStore: StoreOf<ExpenseMap>

		var isNoteEnabled: Bool = false
		var isLocationEnabled: Bool = false

		init (selectedCoordinate: Coordinate?) {
			expenseMapStore = .init(
				initialState: .init(
					selectedCoordinate: selectedCoordinate?.clLocationCoordinate2d
				)
			) {
				ExpenseMap()
			}
		}
	}
}
