import SwiftUI

public protocol BaseScreen: View {
    func viewDidLoad()
}

extension BaseScreen {
    func viewDidLoad() {}
}

extension BaseScreen {
    
    var viewController: BaseHostingViewController<Self>? {
        guard let rootNavigationViewController = UIApplication.shared.rootNavigationViewController else { return nil }
        // finding in rootNavigationViewController
        if let vc = findViewController(rootNavigationViewController.viewControllers) {
            return vc
        }
        
        // finding in TabBarControllers
        let tabBarController = rootNavigationViewController.viewControllers.first(where: { $0 is UITabBarController }) as? UITabBarController
        if let vc = findViewController(tabBarController?.viewControllers) {
            return vc
        }
        // finding in NavigationViewController in TabBarController
        let childNavigationViewController = tabBarController?.viewControllers?.first(where: { $0 is CustomNavigationController }) as? CustomNavigationController
        if let vc = findViewController(childNavigationViewController?.viewControllers) {
            return vc
        }
        
        if let vc = childNavigationViewController?.presentedViewController as? BaseHostingViewController<Self> {
            return vc
        }
        
        if let vc = rootNavigationViewController.presentedViewController as? BaseHostingViewController<Self> {
            return vc
        }
        
        return nil
    }
    
    var navigationController: CustomNavigationController? { viewController?.navigationController as? CustomNavigationController }
    
    private func findViewController(_ constollers: [UIViewController]?) -> BaseHostingViewController<Self>? {
        constollers?.first(where: { $0 is BaseHostingViewController<Self> }) as? BaseHostingViewController<Self>
    }
}
