import SwiftUI

struct ViewControllerHolder {
    weak var value: ScreenViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static let defaultValue: ViewControllerHolder = ViewControllerHolder(value: nil)
}

extension EnvironmentValues {
    var viewController: ScreenViewController? {
        get { self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self] = ViewControllerHolder(value: newValue) }
    }
}

class ScreenViewController: UIViewController, SupportViewModelProtocol {
    
    private let viewFactory: (ScreenViewController) -> any BaseScreen
    internal var viewModels: [BaseViewModel] = []
    
    private var hostingController: UIViewController?
    
    init(viewFactory: @escaping (ScreenViewController) -> any BaseScreen) {
        self.viewFactory = viewFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = viewFactory(self)
            
        let hostingController = UIHostingController(rootView: AnyView(swiftUIView.environment(\.viewController, self)))
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.hostingController = hostingController
        
        swiftUIView.viewDidLoad()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            viewModels.forEach { $0.onCanceled() }
            viewModels.removeAll()
            
            hostingController?.willMove(toParent: nil)
            hostingController?.view.removeFromSuperview()
            hostingController?.removeFromParent()
            hostingController = nil
        }
    }
    
    func addViewModel(_ vm: BaseViewModel) {
        viewModels.append(vm)
    }
}
