enum Source<T> {
    case processing
    case success(_ data: T?)
    case error(_ error: Error?)
}

extension Source {
    var isSuccess: Bool? {
        switch self {
        case .success: return true
        default: break
        }
        return false
    }
    
    var isProcessing: Bool? {
        switch self {
        case .processing: return true
        default: break
        }
        return false
    }
    
    var successObj: T? {
        switch self {
        case .success(let obj): return obj
        default: break
        }
        return nil
    }
    
    var error: Error? {
        switch self {
        case .error(let error): return error
        default: break
        }
        return nil
    }
}
