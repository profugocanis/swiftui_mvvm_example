import Foundation
import Alamofire

open class BaseUseCase {
    
    func handle<T: Decodable>(_ callback: () async throws -> T) async -> Source<T> {
        do {
            return .success(try await callback())
        } catch {
            if let afError = error as? AFError, let code = afError.responseCode {
                switch code {
                case 500...599: return .error(CustomError("Oops, something went wrong!"))
                case 403: return .error(CustomError("Forbidden"))
                default: break
                }
            }
            return .error(error)
        }
    }
}
