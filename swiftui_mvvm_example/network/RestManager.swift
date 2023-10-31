import Alamofire
import Foundation

private let TAG = "Rest"

class RestManager {
    
    private let session: Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForResource = 10
        session = Alamofire.Session(configuration: configuration)
        
    #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    #endif
    }
    
    func fetch<T: Decodable>(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil) async throws -> T {
        let response = try await session.requestAsync(url, method: method, parameters: parameters)
        return try parseResponse(response)
    }
    
    private func parseResponse<T: Decodable>(_ response: AFDataResponse<Data>) throws -> T {
        if let error = response.error { throw error }
        if let data = response.data {
            AppLoger.d(tag: TAG, String(data: data, encoding: .utf8))
            let obj = try JSONDecoder().decode(T.self, from: data)
            return obj
        }
        throw NSError()
    }
}
