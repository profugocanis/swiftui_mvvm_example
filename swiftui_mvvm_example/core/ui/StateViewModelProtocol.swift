import Foundation

protocol StateViewModelProtocol<STATE> {
    associatedtype STATE: BaseState
    var state: STATE! { get set }
}
