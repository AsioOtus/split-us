import Foundation

public enum PersistentError: Error {
	case entityNotFound(id: UUID, entity: String)
	case relatedEntityNotFound(id: UUID, entity: String)
	case integrityFault(String)
}
