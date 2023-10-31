import Foundation

@propertyWrapper
public class Inject<T> {
    public let wrappedValue: T

    public init() {
        let instance: T? = appContainer.resolve(T.self)
        if instance == nil {
            fatalError("\(T.self) nil state")
        }
        self.wrappedValue = instance!
    }
    
    static func get<OBJECT>() -> OBJECT {
        let instance: OBJECT? = appContainer.resolve(OBJECT.self)
        if instance == nil {
            fatalError("\(OBJECT.self) nil state")
        }
        return instance!
    }
}
