import ComposableArchitecture
import MapKit
import SwiftUI

extension ExpenseMap {
	public struct Screen: View {
		@Bindable private var vm: ViewModel

		public init (store: StoreOf<ExpenseMap>) {
			self.vm = .init(store: store)
		}

		public var body: some View {
			contentView()
				.onAppear {
					vm.store.send(.initialize)
				}
				.sheet(
					item: $vm.store.scope(state: \.coordinateSelectionMap, action: \.coordinateSelectionMap)
				) { store in
					CoordinateSelectionMap.Screen(store: store)
						.navigationBarTitleDisplayMode(.inline)
				}
		}

		private func contentView () -> some View {
			Map(position: vm.positionBinding, interactionModes: []) {
				UserAnnotation()

				if let coordinate = vm.store.selectedCoordinate {
					Marker("", systemImage: "dollarsign", coordinate: coordinate)
				}
			}
			.onMapCameraChange { updateContext in
				vm.store.send(.onCoordinateChanged(updateContext.camera.centerCoordinate))
			}
			.onTapGesture {
				vm.store.send(.onExpandButtonTap)
			}
		}
	}
}
