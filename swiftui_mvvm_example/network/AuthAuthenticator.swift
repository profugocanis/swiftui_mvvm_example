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
        
    }
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        
    }
    
    struct OAuthCredential: AuthenticationCredential {
        
        let accessToken: String
        let refreshToken: String
        
        var requiresRefresh: Bool{
            return false
        }
    }
}
