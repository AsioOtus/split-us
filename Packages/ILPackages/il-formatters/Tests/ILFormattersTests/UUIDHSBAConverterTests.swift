import Foundation
import Multitool
import XCTest

@testable import ILFormatters

final class UUIDHSBAConverterTests: XCTestCase {
	let sut = UUIDHSVAConverter()

	func test_plainConversion_hue () {
		// Given
		let ids: [UUID] = [
			.init(uuidString: "00000000-0000-0000-0000-000000000000")!,
			.init(uuidString: "00000000-0000-0000-0000-000000000001")!,
			.init(uuidString: "00000000-0000-0000-0000-000000000002")!,
			.init(uuidString: "00000000-0000-0000-0000-00000000000A")!,
			.init(uuidString: "00000000-0000-0000-0000-00000000000F")!,
			.init(uuidString: "00000000-0000-0000-0000-000000000010")!,
			.init(uuidString: "00000000-0000-0000-0000-00000000001F")!,
			.init(uuidString: "00000000-0000-0000-0000-0000000000FF")!,
		]

		let expectedHsbas: [HSVA] = [
			.init(h: 0, s: 0, v: 0),
			.init(h: 1/255, s: 0, v: 0),
			.init(h: 2/255, s: 0, v: 0),
			.init(h: 10/255, s: 0, v: 0),
			.init(h: 15/255, s: 0, v: 0),
			.init(h: 16/255, s: 0, v: 0),
			.init(h: 31/255, s: 0, v: 0),
			.init(h: 255/255, s: 0, v: 0),
		]

		// When
		let resultHsbas = ids.map(sut.convertPlain)

		// Then
		XCTAssertEqual(resultHsbas, expectedHsbas)
	}

	func test_conversion_saturation () {
		// Given
		let ids: [UUID] = [
			.init(uuidString: "00000000-0000-0000-0000-000000000000")!,
			.init(uuidString: "00000000-0000-0001-0000-000000000000")!,
			.init(uuidString: "00000000-0000-0002-0000-000000000000")!,
			.init(uuidString: "00000000-0000-000F-0000-000000000000")!,
			.init(uuidString: "00000000-0000-00FF-0000-000000000000")!,
		]

		let expectedHsbas: [HSVA] = [
			.init(h: 0, s: 0.7, v: 0.6),
			.init(h: 0, s: 0.7011764705882353, v: 0.6),
			.init(h: 0, s: 0.7023529411764705, v: 0.6),
			.init(h: 0, s: 0.7176470588235294, v: 0.6),
			.init(h: 0, s: 1.0, v: 0.6),
		]

		// When
		let resultHsbas = ids.map(sut.convert)

		// Then
		XCTAssertEqual(resultHsbas, expectedHsbas)
	}
}
