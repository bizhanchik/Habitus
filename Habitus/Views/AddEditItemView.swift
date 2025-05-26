import SwiftUI

struct AddEditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HabitViewModel
    
    let editingItem: HabitItem?
    
    @State private var title = ""
    @State private var type = "task"
    @State private var notes = ""
    @State private var priority: Int16 = 0
    @State private var dueDate: Date?
    @State private var showDueDate = false
    
    @State private var showValidationError = false
    
    private var isEditing: Bool { editingItem != nil }
    
    init(viewModel: HabitViewModel, editingItem: HabitItem? = nil) {
        self.viewModel = viewModel
        self.editingItem = editingItem
        
        if let item = editingItem {
            _title = State(initialValue: item.title ?? "")
            _type = State(initialValue: item.type ?? "task")
            _notes = State(initialValue: item.notes ?? "")
            _priority = State(initialValue: item.priority)
            _dueDate = State(initialValue: item.dueDate)
            _showDueDate = State(initialValue: item.dueDate != nil)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .font(.headline)
                    
                    Picker("Type", selection: $type) {
                        Text("Task").tag("task")
                        Text("Habit").tag("habit")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                } header: {
                    Text("Notes")
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        Text("None").tag(Int16(0))
                        Text("Low").tag(Int16(1))
                        Text("Medium").tag(Int16(2))
                        Text("High").tag(Int16(3))
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Toggle("Set Due Date", isOn: $showDueDate)
                    
                    if showDueDate {
                        DatePicker(
                            "Due Date",
                            selection: Binding(
                                get: { dueDate ?? Date() },
                                set: { dueDate = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        saveItem()
                    }
                    .bold()
                }
            }
            .alert("Title Required", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a title for your item.")
            }
        }
    }
    
    private func saveItem() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationError = true
            return
        }
        
        if isEditing, let item = editingItem {
            viewModel.updateItem(
                item,
                title: title,
                type: type,
                notes: notes.isEmpty ? nil : notes,
                priority: priority,
                dueDate: showDueDate ? dueDate : nil
            )
        } else {
            viewModel.addItem(
                title: title,
                type: type,
                notes: notes.isEmpty ? nil : notes,
                priority: priority,
                dueDate: showDueDate ? dueDate : nil
            )
        }
        
        dismiss()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = HabitViewModel(context: context)
    
    return AddEditItemView(viewModel: viewModel)
} 