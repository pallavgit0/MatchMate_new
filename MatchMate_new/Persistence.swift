
import CoreData

struct PersistenceController {
    static let shared = PersistenceController() 
    
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name:  "CoreDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
}
