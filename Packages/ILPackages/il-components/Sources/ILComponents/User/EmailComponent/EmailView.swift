import SwiftUI

public struct EmailView: View {
	let email: String
	
	public init (email: String) {
		self.email = email
	}
	
	public var body: some View {
		Text(email)
	}
}
