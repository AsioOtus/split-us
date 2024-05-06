import NetworkUtil

public extension URLRequestConfiguration {
	private static let standard = Self(
		scheme: "http",
		address: "",
		port: 33001,
		baseSubpath: "api/v0.1",
		headers: ["Content-Type": "application/json; charset=utf-8"],
		timeout: 10
	)

	static let testVm: Self = .standard.setAddress("154.56.63.78").setBaseSubpath("api/v0.2")
	static let dev149: Self = .standard.setAddress("192.168.0.149").setBaseSubpath("api/v0.2")
	static let dev150: Self = .standard.setAddress("192.168.0.150").setBaseSubpath("api/v0.2")
	static let dev151: Self = .standard.setAddress("192.168.0.151").setBaseSubpath("api/v0.2")
	static let phone: Self = .standard.setAddress("172.20.10.2")
	static let localhost: Self = .standard.setAddress("127.0.0.1")
}
