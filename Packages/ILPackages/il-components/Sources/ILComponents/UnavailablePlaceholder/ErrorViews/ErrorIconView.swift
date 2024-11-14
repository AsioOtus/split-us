import SwiftUI
import ILDesignResources

public struct ErrorIconView: View {
	public init () { }
	
	public var body: some View {
		Image(systemName: .sinGeneralError)
			.foregroundStyle(.red.secondary)
	}
}
