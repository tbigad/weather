import Foundation
import CoreData

enum NetworkError {
    case unreachable
    case loginError
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
    
    func fail() {
        finish()
    }
    
    func succes() {
        finish()
    }
}
