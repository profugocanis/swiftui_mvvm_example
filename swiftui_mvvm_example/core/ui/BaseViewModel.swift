import Foundation

open class BaseViewModel: ObservableObject {

    private var tasks = [Task<(), Never>]()
    
    func task(_ operation: @escaping () async -> Void) {
        let t = Task(priority: .high) {
            await operation()
        }
        tasks.append(t)
    }
    
    open func onCanceled() {
        tasks.forEach { $0.cancel() }
    }
}
