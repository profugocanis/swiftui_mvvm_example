import Swinject

let swinjectContainer = Container()

open class BaseAppComponent {
    
    public func inject<T>() -> T? {
        swinjectContainer.resolve(T.self)
    }
    
    func injectViewModel<T: BaseViewModel>(_ vc: ScreenViewController?) -> T {
        if let viewModel: T = swinjectContainer.resolve(T.self) {
            vc?.addViewModel(viewModel)
            return viewModel
        } else {
            fatalError("No instance of BaseViewModel found in AppContainer")
        }
    }

    public func factory<T: AnyObject>(_ create: @escaping (Resolver) -> T) {
        swinjectContainer.register(T.self) { r in
            create(r)
        }
    }

    public func singelton<T: AnyObject>(_ create: @escaping (Resolver) -> T) {
        swinjectContainer.register(T.self) { r in
            create(r)
        }.inObjectScope(.container)
    }
}

extension Resolver {
    
    func get<T>() -> T? {
        resolve(T.self)
    }
}
