//
//  Persistence.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for preview
        let sampleItems = [
            ("Morning Meditation", "habit", "Start the day with 10 minutes of meditation", 2),
            ("Read a Book", "habit", "Read at least 30 pages", 1),
            ("Complete Project", "task", "Finish the SwiftUI project", 3),
            ("Exercise", "habit", "30 minutes workout", 2),
            ("Review Tasks", "task", "Review and plan for tomorrow", 1)
        ]
        
        for (title, type, notes, priority) in sampleItems {
            let newItem = HabitItem(context: viewContext)
            newItem.id = UUID()
            newItem.title = title
            newItem.type = type
            newItem.notes = notes
            newItem.priority = Int16(priority)
            newItem.isComplete = Bool.random()
            newItem.createdAt = Date()
            newItem.updatedAt = Date()
            if Bool.random() {
                newItem.dueDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...7), to: Date())
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Habitus")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
