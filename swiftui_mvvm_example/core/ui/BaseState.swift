import Foundation
import SwiftUICore

open class BaseState: ObservableObject {
    
    internal func showError(_ error: Error?) {
        CustomAlertDialog.showInfo(error?.localizedDescription ?? "nil")
    }
    
    internal func showError(_ error: String?) {
        CustomAlertDialog.showInfo(error ?? "nil")
    }
    
    func observedObject<T: BaseState>() -> ObservedObject<T> {
        ObservedObject(wrappedValue: self as! T)
    }
}
