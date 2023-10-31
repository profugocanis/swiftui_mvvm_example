import SwiftUI

public protocol BaseScreen: View { }

extension BaseScreen {
    
    var navigation: CustomNavigationController? { viewController?.navigationController as? CustomNavigationController }
    
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
    
    private func findViewController(_ constollers: [UIViewController]?) -> BaseHostingViewController<Self>? {
        constollers?.first(where: { $0 is BaseHostingViewController<Self> }) as? BaseHostingViewController<Self>
    }
}
