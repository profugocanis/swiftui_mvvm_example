import Foundation

extension Data {
    
    func toString() -> String {
        String(decoding: self, as: UTF8.self)
    }
}
