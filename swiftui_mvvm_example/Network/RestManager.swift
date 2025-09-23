import Alamofire
import Foundation

private let TAG = "Rest"

class RestManager {
    
    private let session: Session
    
    private let dataDecoder: JSONDecoder
    
    init() {
        
        dataDecoder = JSONDecoder()
        dataDecoder.dateDecodingStrategy = .iso8601
        
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForResource = 10
        
        let interceptor = AuthenticationInterceptor(
            authenticator: AuthAuthenticator(),
            credential: AuthAuthenticator.OAuthCredential()
        )
        
        session = Alamofire.Session(configuration: configuration, interceptor: interceptor)
        
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        #endif
    }
    
    func fetch<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        payload: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
    ) async throws -> T {
        let dataResponse = await AF.request(
            url,
            method: method,
            parameters: payload,
            encoding: encoding,
        )
            .validate()
            .serializingData()
            .response
        
        if let error = dataResponse.error {
            throw error
        }
        
        let data = dataResponse.data ?? Data()
        if let d = data as? T, T.self == Data.self {
            return d
        }
        return try dataDecoder.decode(T.self, from: data)
    }
    
    private func parseToJSONObject(_ data: Data?) throws -> [String: Any]? {
        guard let data = data else {
            throw CustomError("No data to parse")
        }
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
