import DLModels

public struct SplitModeSymbolFormatter {
	public static let `default` = Self()

	public func symbolName (_ splitMode: SplitMode) -> String {
		switch splitMode {
		case .exact: "textformat.123"
		case .percent: "percent"
		case .parts: "divide"
		}
	}
}
