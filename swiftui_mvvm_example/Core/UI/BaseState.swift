import Foundation
import SwiftUI

open class BaseState: ObservableObject {
    
    internal func showErrorDialog(_ error: Error?) {
        if let afError = error?.asAFError {
            CustomAlertDialog.showInfo(afError.errorDescription ?? "nil")
        } else {
            CustomAlertDialog.showInfo(error?.localizedDescription ?? "nil")
        }
    }
    
    internal func showErrorDialog(_ error: String?) {
        CustomAlertDialog.showInfo(error ?? "nil")
    }
}
