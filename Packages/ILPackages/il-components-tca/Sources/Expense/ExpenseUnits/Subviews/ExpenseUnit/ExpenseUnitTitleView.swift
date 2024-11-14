import DLModels
import SwiftUI

public struct ExpenseUnitTitleView: View {
	let expenseInfo: ExpenseInfo

	public init (expenseInfo: ExpenseInfo) {
		self.expenseInfo = expenseInfo
	}

	public var body: some View {
		HStack(spacing: 8) {
			VStack(alignment: .leading, spacing: 2) {
				nameView()
				metaView()
			}
		}
	}
}

private extension ExpenseUnitTitleView {
	func metaView () -> some View {
		HStack(alignment: .firstTextBaseline) {
			if let date = expenseInfo.date.flatMap({ DateFormatter.with(time: $0.hasTime() == true).string(for: $0) }) {
				dateView(date)
			}

			iconsView()
		}
	}

	@ViewBuilder
	func nameView () -> some View {
		if let name = expenseInfo.name {
			Text(name)
				.font(.callout)
		} else {
			Text(.domainWithoutName)
				.font(.callout)
				.fontWeight(.light)
				.foregroundStyle(.secondary)
				.italic()
		}
	}

	func dateView (_ date: String) -> some View {
		Text(date)
			.foregroundStyle(.secondary)
			.font(.caption)
	}

	func iconsView () -> some View {
		HStack(spacing: 4) {
			if expenseInfo.note != nil {
				Text(
					Image(systemName: "note.text")
				)
			}

			if expenseInfo.coordinate != nil {
				Text(
					Image(systemName: "location.fill")
				)
			}
		}
		.font(.caption2)
		.foregroundStyle(.tint)
	}
}

#Preview {
	ExpenseUnitTitleView(
		expenseInfo: .init(
			name: "Поездка на природу",
			note: "Заметки",
			date: .init(),
			timeZone: .current,
			coordinate: .init(latitude: 1, longitude: 1)
		)
	)
}
