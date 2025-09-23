import Foundation

extension Data {
    
    func toString() -> String? {
        String(data: self, encoding: .utf8)
    }
}
