import Alamofire
import Foundation

/// The level of logging detail.
public enum NetworkActivityLoggerLevel {
    /// Do not log requests or responses.
    case off
    
    /// Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
    case debug
    
    /// Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
    case info
    
    /// Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
    case warn
    
    /// Equivalent to `.warn`
    case error
    
    /// Equivalent to `.off`
    case fatal
}

/// `NetworkActivityLogger` logs requests and responses made by Alamofire.SessionManager, with an adjustable level of detail.
public class NetworkActivityLogger {
    // MARK: - Properties
    
    /// The shared network activity logger for the system.
    public static let shared = NetworkActivityLogger()
    
    public var uploadTempBody: String?
    
    /// The level of logging detail. See NetworkActivityLoggerLevel enum for possible values. .info by default.
    public var level: NetworkActivityLoggerLevel
    
    /// Omit requests which match the specified predicate, if provided.
    public var filterPredicate: NSPredicate?
    
    private let queue = DispatchQueue(label: "\(NetworkActivityLogger.self) Queue")
    
    // MARK: - Internal - Initialization
    
    init() {
        level = .debug
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setFilterUrl(_ url: String) {
        filterPredicate = NSPredicate(block: { it, _ in
            if let urlRequest = it as? URLRequest {
                if "\(urlRequest)".contains(url) {
                    return false
                }
            }
            return true
        })
    }
    
    // MARK: - Logging
    
    /// Start logging requests and responses.
    public func startLogging() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(NetworkActivityLogger.requestDidStart(notification:)),
            name: Request.didResumeTaskNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(NetworkActivityLogger.requestDidFinish(notification:)),
            name: Request.didFinishNotification,
            object: nil
        )
    }
    
    // MARK: - Private - Notifications
    
    @objc private func requestDidStart(notification: Notification) {
        queue.async {
            guard let dataRequest = notification.request as? DataRequest,
                let task = dataRequest.task,
                let request = task.originalRequest,
                let httpMethod = request.httpMethod,
                let requestURL = request.url
                else {
                    return
            }
            
            if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
                return
            }
            
            switch self.level {
            case .debug:
                self.logDivider()
                
                printLog("---> \(httpMethod) \(requestURL.absoluteString)")
                self.logHeaders(headers: dataRequest.request?.headers.dictionary ?? [:])
                var body = String(describing: dataRequest.request?.httpBody?.toString() ?? "nil")
                if body == "nil", let uploadTempBody = self.uploadTempBody {
                    body = uploadTempBody
                    self.uploadTempBody = nil
                }
                printLog("Body: \(body)", isSeparator: false)
                printLog("---> END \(httpMethod)")
            case .info:
                self.logDivider()
                
                printLog("\(httpMethod) '\(requestURL.absoluteString)'")
            default:
                break
            }
        }
    }
    
    @objc private func requestDidFinish(notification: Notification) {
        queue.async {
            guard let dataRequest = notification.request as? DataRequest,
                let task = dataRequest.task,
                let metrics = dataRequest.metrics,
                let request = task.originalRequest,
                let httpMethod = request.httpMethod,
                let requestURL = request.url
                else {
                    return
            }
            
            if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
                return
            }
            
            let elapsedTime = metrics.taskInterval.duration
            
            if let error = task.error {
                switch self.level {
                case .debug, .info, .warn, .error:
                    self.logDivider()
                    
                    printLog("[Error] \(httpMethod) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
                    printLog(error)
                default:
                    break
                }
            } else {
                guard let response = task.response as? HTTPURLResponse else {
                    return
                }
                
                switch self.level {
                case .debug:
                    self.logDivider()
                    
                    printLog("<--- \(String(describing: dataRequest.firstRequest?.method?.rawValue ?? "")) \(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
                    
                    self.logHeaders(headers: response.allHeaderFields)
                    
                    guard let data = dataRequest.data else { break }
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        
                        if let prettyString = String(data: prettyData, encoding: .utf8) {
                            printLog("Body:")
                            printLog(prettyString, isSeparator: false)
                        }
                    } catch {
                        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                            printLog("Body: \(string)")
                        }
                    }
                case .info:
                    self.logDivider()
                    printLog("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]")
                default:
                    break
                }
            }
        }
        
    }
}

private extension NetworkActivityLogger {
    func logDivider() {
        printLog("------------------------------")
    }
    
    func logHeaders(headers: [AnyHashable: Any]) {
        printLog("Headers: [")
        for (key, value) in headers {
            printLog("  \(key): \(value)")
        }
        printLog("]")
    }
}

private func printLog(_ items: Any, isSeparator: Bool = true) {
    
    if isSeparator {
        String(describing: items)
            .split(separator: "\n")
            .forEach { it in
                print("🌐 network: \(it)")
            }
    } else {
        let msg = String(describing: items)
            .replace("\n", value: "")
            .replace("  ", value: "")
            .replace(" :", value: ":")
            .replace(",", value: ", ")
        print("🌐 network: \(msg)")
    }
}

// MARK: String ext
extension String {
    
    func replace(_ reg: String, value: Any) -> String {
        let regex = try? NSRegularExpression(pattern: reg, options: NSRegularExpression.Options.caseInsensitive)
        let range = NSRange(location: 0, length: self.count)
        let modString = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\(value)")
        return modString ?? self
    }
}
