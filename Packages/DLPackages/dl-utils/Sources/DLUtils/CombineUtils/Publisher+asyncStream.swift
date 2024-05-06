import Combine

public extension Publisher {
	var asyncStream: AsyncThrowingStream<Output, some Error> {
		.init { continuation in
			let cancellable = self
				.sink(
					receiveCompletion: {
						if case .failure(let error) = $0 {
							continuation.finish(throwing: error)
						} else {
							continuation.finish()
						}
					},
					receiveValue: {
						continuation.yield($0)
					}
				)

			continuation.onTermination = { _ in
				cancellable.cancel()
			}
		}
	}
}

public extension Publisher where Failure == Never {
	var asyncStream: AsyncStream<Output> {
		.init { continuation in
			let cancellable = self
				.sink(
					receiveCompletion: { _ in
						continuation.finish()
					},
					receiveValue: {
						continuation.yield($0)
					}
				)

			continuation.onTermination = { _ in
				cancellable.cancel()
			}
		}
	}
}
