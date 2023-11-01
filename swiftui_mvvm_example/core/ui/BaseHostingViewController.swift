import SwiftUI

var allViewControllers = [UIViewController]()

class BaseHostingViewController<Content>: UIHostingController<Content>, SupportViewModelProtocol where Content: View {
    
    internal var viewModels: [BaseViewModel] = []
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
        allViewControllers.append(self)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (rootView as? (any BaseScreen))?.viewDidLoad()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            viewModels.forEach { $0.onCanceled() }
            viewModels.removeAll()
            
            allViewControllers.removeAll { $0 == self }
        }
    }
    
    func addViewModel(_ vm: BaseViewModel) {
        viewModels.append(vm)
    }
    
    func getViewModel<T: BaseViewModel>() -> T? {
        return viewModels.first { $0 is T } as? T
    }
}
