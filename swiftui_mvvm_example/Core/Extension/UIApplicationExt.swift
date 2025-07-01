import UIKit

extension UIApplication {
    
    var isLeftToRight: Bool {
        userInterfaceLayoutDirection == .leftToRight
    }
    
    var window: UIWindow? {
        let windowScene = connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
    
    var rootNavigationViewController: CustomNavigationController? {
        window?.rootViewController as? CustomNavigationController
    }
}
