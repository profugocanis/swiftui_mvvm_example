import SwiftUI

protocol BaseScreen: View {
    func viewDidLoad()
}

extension BaseScreen {
    func viewDidLoad() {}
}

extension BaseScreen {
    
    var navigationController: CustomNavigationController? { viewController.navigationController as? CustomNavigationController }
    
    var viewController: BaseHostingViewController<Self> {
        let vc = allViewControllers.first {
            $0 as? BaseHostingViewController<Self> != nil
        } as? BaseHostingViewController<Self>
        return vc!
    }
}

// MARK: inject
extension BaseScreen {
    
    internal func injectViewModel<VM: BaseViewModel & StateViewModelProtocol, ST: BaseState>(_ state: ST) -> VM {
        var vm: VM = injectViewModel()
        if vm.state == nil {
            vm.state = state as? VM.STATE
        }
        return vm
    }
    
    internal func injectViewModel<VM: BaseViewModel>() -> VM {
        if let vm: VM = viewController.getViewModel() {
            return vm
        }
        let vm: VM = getViewModel()
        viewController.addViewModel(vm)
        return vm
    }
    
    private func getViewModel<VM: BaseViewModel>() -> VM {
        let instance = appContainer.resolve(VM.self)
        if instance == nil {
            fatalError("\(VM.self) nil state")
        }
        return instance!
    }
}
