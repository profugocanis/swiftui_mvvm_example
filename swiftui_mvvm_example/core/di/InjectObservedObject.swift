import SwiftUI

@propertyWrapper
struct InjectObservedObject<T: ObservableObject>: DynamicProperty {
    
    @ObservedObject private var state: T

    init() {
        let instance = swinjectContainer.resolve(T.self)
        if instance == nil {
            fatalError("No instance of \(T.self) found in AppContainer")
        }
        self._state = ObservedObject(wrappedValue: instance!)
    }

    var wrappedValue: T { state }
    var projectedValue: ObservedObject<T>.Wrapper { $state }
}
