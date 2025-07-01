import Foundation

@propertyWrapper
public class InjectLazy<T> {
    
    private var instance: T?
    
    public var wrappedValue: T {
        if instance == nil {
            instance = swinjectContainer.resolve(T.self)
        }
        return instance!
    }
    
    public init() {}
}
