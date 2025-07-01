import Foundation
import SwiftUICore

open class BaseState: ObservableObject {
    
    internal func showErrorDialog(_ error: Error?) {
        CustomAlertDialog.showInfo(error?.localizedDescription ?? "nil")
    }
    
    internal func showErrorDialog(_ error: String?) {
        CustomAlertDialog.showInfo(error ?? "nil")
    }
    
    func observedObject<T: BaseState>() -> ObservedObject<T> {
        ObservedObject(wrappedValue: self as! T)
    }
}
