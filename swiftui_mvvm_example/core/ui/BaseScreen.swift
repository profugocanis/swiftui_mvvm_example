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
