import Foundation
import Multitool

public struct UUIDHSVAConverter {
	public typealias UUIDComponents = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

	public static let `default` = Self()

	let hueUuidKeyPath: KeyPath<UUIDComponents, UInt8> = \.15
	let saturationUuidKeyPath: KeyPath<UUIDComponents, UInt8> = \.7
	let brightnessUuidKeyPath: KeyPath<UUIDComponents, UInt8> = \.0

	let saturationMin = 0.7
	let saturationMax = 1.0

	let brightnessMin = 0.6
	let brightnessMax = 0.75

	public func convert (_ uuid: UUID) -> HSVA {
		let hsva = convertPlain(uuid)

		let adjustedSaturation = hsva.saturation.scaled(newMin: saturationMin, newMax: saturationMax)
		let adjustedBrightness = hsva.value.scaled(newMin: brightnessMin, newMax: brightnessMax)

		return .init(
			h: hsva.hue,
			s: adjustedSaturation,
			v: adjustedBrightness
		)
	}

	func convertPlain (_ uuid: UUID) -> HSVA {
		.init(
			h: Double(uuid.uuid[keyPath: hueUuidKeyPath]) / 255,
			s: Double(uuid.uuid[keyPath: saturationUuidKeyPath]) / 255,
			v: Double(uuid.uuid[keyPath: brightnessUuidKeyPath]) / 255
		)
	}
}
