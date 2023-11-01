import Foundation
import Combine

open class BaseViewModel: ObservableObject {

    private var tasks = [Task<(), Never>]()
    internal var subscriptions = Set<AnyCancellable>()
    
    func task(_ operation: @escaping () async -> Void) {
        let t = Task(priority: .high) {
            await operation()
        }
        tasks.append(t)
    }
    
    open func onCanceled() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}
