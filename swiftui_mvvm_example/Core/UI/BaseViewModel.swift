import Foundation
import Combine
import Alamofire

open class BaseViewModel: ObservableObject {

    private var tasks = [Task<(), Never>]()
    var cancellables = Set<AnyCancellable>()
    
    func task(_ operation: @escaping () async -> Void) {
        let t = Task(priority: .high) {
            await operation()
        }
        tasks.append(t)
    }
    
    open func onCanceled() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    @MainActor
    func launchSafely(
        launch: @escaping () async throws -> Void,
        onError: @escaping (Error) -> Void,
    ) {
        task {
            do {
                try await launch()
            } catch {
                onError(ErrorHandler.handleError(error))
            }
        }
    }
    
    deinit {
        onCanceled()
    }
}

open class ErrorHandler {
    
    static func handleError(_ error: Error) -> Error {
        if let afError = error as? AFError, let code = afError.responseCode {
            switch code {
            case 401:
                return NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
            case 426:
                return NSError(domain: "", code: 426, userInfo: [NSLocalizedDescriptionKey: "Old version"])
            case 500...599:
                return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: "Oops"])
            default:
                return error
            }
        }
        return error
    }
}
