import SwiftUI

struct MapSightView: View {
	var body: some View {
		MapSightShape()
			.stroke(
				.red,
				style: .init(
					lineWidth: 2,
					lineCap: .round
				)
			)
			.background {
				MapSightShape()
					.stroke(
						.white,
						style: .init(
							lineWidth: 4,
							lineCap: .round
						)
					)
					.shadow(color: .gray, radius: 3, y: 1)
			}
	}
}
