import Foundation

class CustomError: LocalizedError {
    
    private let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        message
    }
}
