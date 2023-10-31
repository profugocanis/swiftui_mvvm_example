import Foundation
import Alamofire

extension Session {
    
    func requestAsync(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      interceptor: RequestInterceptor? = nil,
                      requestModifier: RequestModifier? = nil) async throws -> AFDataResponse<Data> {
        try await withUnsafeThrowingContinuation { continuation in
            request(convertible, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor, requestModifier: requestModifier)
                .validate()
                .responseData { response in
                    continuation.resume(with: .success(response))
                }
        }
    }
}
