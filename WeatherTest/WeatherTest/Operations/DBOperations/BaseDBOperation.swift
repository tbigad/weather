import Foundation
import CoreData

class BaseDBOperation: AsyncOperation {
    
    init(int:Int) {
        super.init()
    }
    var mainContext:NSManagedObjectContext!
    var backgroundContext:NSManagedObjectContext!
    
    
    func saveContext(context ctx: NSManagedObjectContext) {
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
