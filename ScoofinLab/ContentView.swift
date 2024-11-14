import SwiftUI
import Dependencies
import DLPersistence
import DLModels

struct ContentView: View {
	@State private var username: String = ""
	@State private var users: [User.Compact] = []

	@Dependency(\.userPersistentRepository) var userRepository

	var body: some View {
		NavigationStack {
			List {
				TextField("Username", text: $username)

				ForEach(users, id: \.self) { user in
					HStack {
						Text(user.username)
						Text(user.id.uuidString)
					}
				}
			}
			.refreshable {
				users = try! userRepository.loadContacts(page: 0, pageSize: 100)
			}
			.toolbar {
				ToolbarItem {
					Button("Add", systemImage: "plus") {
						try! userRepository.saveUser(
							.init(
								id: .init(),
								username: username,
								name: nil,
								surname: nil
							)
						)
					}
				}
			}
		}
	}
}
