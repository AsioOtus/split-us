import MapView
import SwiftUI

struct ContentView: View {
	var body: some View {
		EmptyView()
			.sheet(isPresented: .constant(true)) {
				CoordinateSelectionMap.Screen(
					store: .init(initialState: .init()) {
						CoordinateSelectionMap()
					}
				)
			}
	}
}

#Preview {
	ContentView()
}
