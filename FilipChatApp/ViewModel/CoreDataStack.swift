//
//  CoreDataManager.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-21.
//
import CoreData

class CoreDataStack {
    
    
    // A singelton so I have a global access.
    static let shared = CoreDataStack()

    // lazy to be sure that is only created once it's needed.
    // presistentContainer is used to manage the Core Data stack.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Here we set the container to the name of the CoreData.
        let container = NSPersistentContainer(name: "CoreDataMessage")
        
        // Load the persistent stores for the container. Its's responsible to saving and retrieving the data.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // This method is used to save changes to the managed object context
    func saveContext() {
        
        // Get the managed object context from the persistent container
        let context = persistentContainer.viewContext
        
        // If there are changes to the managed object context, save them
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
