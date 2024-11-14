import DLModels
import SwiftUI

public struct ExpenseUnitLayout <
	IconView,
	TitleView,
	AccessoryView,
	ContentView
>: View
where
IconView: View,
TitleView: View,
AccessoryView: View,
ContentView: View
{
	private let iconWidth = 40.0

	let iconView: IconView
	let titleView: TitleView
	let accessoryView: AccessoryView
	let contentView: ContentView

	init (
		@ViewBuilder contentView: () -> ContentView,
		@ViewBuilder iconView: () -> IconView,
		@ViewBuilder titleView: () -> TitleView,
		@ViewBuilder accessoryView: () -> AccessoryView
	) {
		self.contentView = contentView()
		self.iconView = iconView()
		self.titleView = titleView()
		self.accessoryView = accessoryView()
	}

	public var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				iconView
					.frame(width: iconWidth)

				titleView

				Spacer()
				
				accessoryView
			}

			contentView
				.padding(.leading, iconWidth)
		}
	}
}
