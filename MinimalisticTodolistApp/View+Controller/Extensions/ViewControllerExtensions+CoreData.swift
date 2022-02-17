import UIKit
import CoreData

extension UIViewController {

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try self.context.save()
        } catch {
            print("Error occured when saving context: \(error)")
        }
    }

    func fetchEntities<Entity: NSManagedObject>(with request: NSFetchRequest<Entity>) throws -> [Entity] {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching request from context \(error)")
            throw(error)
        }
    }

}
