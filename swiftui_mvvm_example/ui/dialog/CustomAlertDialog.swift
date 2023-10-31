import UIKit

class CustomAlertDialog {
    
    static func showInfo(_ message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.rootNavigationViewController?.present(alert, animated: true, completion: nil)
    }
}


