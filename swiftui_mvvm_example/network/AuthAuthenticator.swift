import Foundation
import Alamofire

class AuthAuthenticator: Authenticator {
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        response.statusCode == 401
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        return true
    }
    
    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        completion(.failure(CustomError("Unauthorized")))
    }
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.init(name: "apikey", value: BuildUtils.shared.moviesApiKey))
    }
    
    struct OAuthCredential: AuthenticationCredential {
        var requiresRefresh: Bool{
            return false
        }
    }
}
