import NetworkUtil

public extension RequestConfiguration {
	private static let standard = Self(
		url: .init(
			scheme: "http",
			port: 33001,
			path: ["api/v0.2"]
		),
		headers: ["Content-Type": "application/json; charset=utf-8"],
		timeout: 10
	)

	static let testVm: Self = .standard.setHost("154.56.63.78")
	static let dev149: Self = .standard.setHost("192.168.0.149")
	static let dev150: Self = .standard.setHost("192.168.0.150")
	static let dev151: Self = .standard.setHost("192.168.0.151")
	static let phone: Self = .standard.setHost("172.20.10.2")
	static let localhost: Self = .standard.setHost("127.0.0.1")
}
