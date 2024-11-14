import SwiftUI

public extension View {
	func asToolbarItem (
		id: String,
		placement: ToolbarItemPlacement = .automatic
	) -> some ToolbarContent {
		ToolbarItem(
			id: id,
			placement: placement,
			content: { self }
		)
	}

	func asToolbarItem (
		placement: ToolbarItemPlacement = .automatic
	) -> some ToolbarContent {
		ToolbarItem(
			placement: placement,
			content: { self }
		)
	}
}
