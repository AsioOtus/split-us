import ILLocalization
import SwiftUI

public struct GeneralErrorLabel: View {
	public init () { }

	public var body: some View {
		Label(
			title: {
				Text(.generalErrorSomethingWentWrong)
			},
			icon: {
				ErrorIconView()
			}
		)
	}
}
