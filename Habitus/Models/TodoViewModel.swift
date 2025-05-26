import Foundation
import CoreData
import SwiftUI

class HabitViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
    @Published var items: [HabitItem] = []
    @Published var showingAddSheet = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var selectedFilter: ItemFilter = .all
    
    enum ItemFilter {
        case all, tasks, habits, completed, incomplete
    }
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchItems()
    }
    
    func fetchItems() {
        let request = HabitItem.fetchRequest()
        
        // Apply filters
        var predicates: [NSPredicate] = []
        switch selectedFilter {
        case .tasks:
            predicates.append(NSPredicate(format: "type == %@", "task"))
        case .habits:
            predicates.append(NSPredicate(format: "type == %@", "habit"))
        case .completed:
            predicates.append(NSPredicate(format: "isComplete == YES"))
        case .incomplete:
            predicates.append(NSPredicate(format: "isComplete == NO"))
        case .all:
            break
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        // Sort by priority (high to low) and then by creation date (newest first)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \HabitItem.priority, ascending: false),
            NSSortDescriptor(keyPath: \HabitItem.createdAt, ascending: false)
        ]
        
        do {
            items = try viewContext.fetch(request)
        } catch {
            showError(message: "Failed to fetch items: \(error.localizedDescription)")
        }
    }
    
    func addItem(title: String, type: String, notes: String? = nil, priority: Int16 = 0, dueDate: Date? = nil) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError(message: "Title cannot be empty")
            return
        }
        
        let newItem = HabitItem(context: viewContext)
        newItem.id = UUID()
        newItem.title = title
        newItem.type = type
        newItem.notes = notes
        newItem.priority = priority
        newItem.dueDate = dueDate
        newItem.createdAt = Date()
        newItem.updatedAt = Date()
        newItem.isComplete = false
        
        saveContext()
        fetchItems()
    }
    
    func toggleCompletion(for item: HabitItem) {
        item.isComplete.toggle()
        item.updatedAt = Date()
        saveContext()
        fetchItems()
    }
    
    func deleteItem(_ item: HabitItem) {
        viewContext.delete(item)
        saveContext()
        fetchItems()
    }
    
    func updateItem(_ item: HabitItem, title: String, type: String, notes: String? = nil, priority: Int16, dueDate: Date? = nil) {
        item.title = title
        item.type = type
        item.notes = notes
        item.priority = priority
        item.dueDate = dueDate
        item.updatedAt = Date()
        saveContext()
        fetchItems()
    }
    
    func setFilter(_ filter: ItemFilter) {
        selectedFilter = filter
        fetchItems()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            showError(message: "Failed to save changes: \(error.localizedDescription)")
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
} 