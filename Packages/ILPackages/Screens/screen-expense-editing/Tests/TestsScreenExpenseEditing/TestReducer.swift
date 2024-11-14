import ComposableArchitecture
import XCTest
@testable import DLServices
@testable import ScreenExpenseEditing

final class TestReducer: XCTestCase {
	override func setUpWithError() throws { }
	override func tearDownWithError() throws { }

	@MainActor
	func testUserLoading () async {
		let store = TestStore(
			initialState: ExpenseEditing.State(
				initialExpenseTree: nil,
				initialCreditor: nil,
				initialRemainingAmountValue: nil,
				isLocal: false,
				superExpenseGroupId: nil,
				userGroup: .init(
					id: .zeros,
					name: ""
				)
			)
		) {
			ExpenseEditing.Reducer()
		} withDependencies: {
			$0.userGroupsService = UserGroupsService.Test(
				users: { _ in
					return []
				}
			)
		}

		await store.send(.initialize) { state in
			state.users.setLoading()
		}

		await store.receive(\.onUsersResponse) { state in
			state.users = .successful([])
			state.amountValueSplitInteractor = .init(users: [], totalAmountValue: state.totalAmountValue)
		}
	}
}
