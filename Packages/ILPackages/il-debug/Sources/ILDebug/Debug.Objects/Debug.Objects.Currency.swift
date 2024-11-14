import DLModels
import DLModelsSamples

extension Debug.Objects {
	public enum Currency {
		public static var eur: DLModels.Currency { .eur }
		public static var usd: DLModels.Currency { .usd }
		public static var rub: DLModels.Currency { .rub }

		public static var all: [DLModels.Currency] { DLModels.Currency.all }
	}
}
