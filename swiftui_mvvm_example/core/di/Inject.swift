import Foundation

@propertyWrapper
public class Inject<T> {
    public let wrappedValue: T

    public init() {
        let instance: T? = swinjectContainer.resolve(T.self)
        if instance == nil {
            fatalError("\(T.self) nil state")
        }
        self.wrappedValue = instance!
    }
}
