import Foundation

open class BaseState: ObservableObject {
    
    internal func showError(_ error: Error?) {
        CustomAlertDialog.showInfo(error?.localizedDescription ?? "nil")
    }
    
    internal func showError(_ error: String?) {
        CustomAlertDialog.showInfo(error ?? "nil")
    }
}
