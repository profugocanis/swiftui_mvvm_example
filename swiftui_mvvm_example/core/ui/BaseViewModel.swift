import Foundation
import Combine

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
}
