import ComposableArchitecture
import ILLocalization
import MapKit
import Multitool
import SwiftUI

extension CoordinateSelectionMap {
	public struct Screen: View {
		@Bindable var vm: ViewModel

		public init (store: StoreOf<CoordinateSelectionMap>) {
			self.vm = .init(store: store)
		}

		public var body: some View {
			contentView()
				.onAppear {
					vm.store.send(.initialize)
				}
				.onDisappear {
					vm.store.send(.deinitialize)
				}
		}

		private func contentView () -> some View {
			ZStack {
				mapView()

				ZStack(alignment: .topLeading) {
					Color.clear
					mapStyleToggle()
				}

				MapSightView()
					.frame(width: 40, height: 40)
			}
			.safeAreaInset(edge: .bottom) {
				selectionButtonsView()
			}
		}
	}
}

// MARK: - Subviews
private extension CoordinateSelectionMap.Screen {
	func mapView () -> some View {
		Map(
			position: vm.positionBinding,
			interactionModes: [.pan, .rotate, .zoom],
			selection: vm.selectedMapFeatureBinding
		) {
			UserAnnotation()

			if let existingCoordinate = vm.store.existingCoordinate {
				Marker("", systemImage: "dollarsign", coordinate: existingCoordinate)
			}
		}
		.mapStyle(vm.mapStyle)
		.mapControls {
			MapUserLocationButton()
			MapCompass()
		}
		.onMapCameraChange { updateContext in
			vm.store.send(.onCoordinateChanged(updateContext.camera.centerCoordinate))
		}
	}

	func selectionButtonsView () -> some View {
		HStack(spacing: 16) {
			Button(role: .cancel) {
				vm.store.send(.onCancelButtonTap)
			} label: {
				HStack {
					Spacer()
					Text(.generalActionCancel)
					Spacer()
				}
			}
			.buttonStyle(.bordered)

			Button {
				vm.store.send(.onSelectButtonTap)
			} label: {
				HStack {
					Spacer()
					Text(.generalActionSelect)
					Spacer()
				}
			}
			.buttonStyle(.borderedProminent)
		}
		.controlSize(.large)
		.padding(.horizontal, 16)
		.padding(.top, 16)
		.background(.background)
		.backgroundStyle(.thinMaterial)
	}

	func mapStyleToggle () -> some View {
		Button("", systemImage: "square.2.layers.3d.top.filled") {
			vm.useHybridMapStyle.toggle()
		}
		.symbolVariant(vm.useHybridMapStyle ? .fill : .none)
		.buttonStyle(.borderedProminent)
		.padding()
		.labelStyle(.iconOnly)
	}
}
