import DLModels
import Multitool

public extension ExpenseGroup {
	static let helsinki = Self.init(
		id: .create(1, 1),
		info: .init(
			name: "Helsinki"
		),
		offlineStatus: .cached,
		creator: .ostap
	)
}
