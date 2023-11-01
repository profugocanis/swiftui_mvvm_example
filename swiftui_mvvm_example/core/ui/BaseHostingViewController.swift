import SwiftUI

class BaseHostingViewController<Content>: UIHostingController<Content>, SupportViewModelProtocol where Content: View {
    
    internal var viewModels: [BaseViewModel] = []
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            viewModels.forEach { $0.onCanceled() }
            viewModels.removeAll()
        }
    }
    
    func addViewModel(_ vm: BaseViewModel) {
        viewModels.append(vm)
    }
}
