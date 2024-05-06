public struct Envelope<ResponseModel: Codable>: Codable {
	public let result: Result<ResponseModel, BackendError>

  public init (_ model: ResponseModel) {
		result = .success(model)
  }

  public init (_ error: BackendError) {
		result = .failure(error)
  }

	public static func model (_ model: ResponseModel) -> Self { .init(model) }
	public static func error (_ error: BackendError) -> Self { .init(error) }
}

extension Envelope: Equatable where ResponseModel: Equatable { }
