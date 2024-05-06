import SwiftUI

public struct OptionView: View {
	@Binding private var isChecked: Bool
	
	private var color: Color {
#if os(iOS)
	isChecked ? Color(UIColor.systemBlue) : Color.secondary
#elseif os(macOS)
	isChecked ? Color(NSColor.systemBlue) : Color.secondary
#endif
	}
	
	public init (_ isChecked: Binding<Bool>) {
		_isChecked =  isChecked
	}
	
	public var body: some View {
		Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
			.foregroundColor(color)
			.onTapGesture { isChecked.toggle() }
	}
}

struct OptionView_Previews: PreviewProvider {
	struct Preview: View {
		@State var checked = false
		
		var body: some View {
			OptionView($checked)
		}
	}
	
	static var previews: some View {
		Preview()
	}
}
