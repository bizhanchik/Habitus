import SwiftUI

struct HabitItemDetailView: View {
    let item: HabitItem
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HabitViewModel
    let onEdit: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text(item.title ?? "")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            viewModel.toggleCompletion(for: item)
                            dismiss()
                        }) {
                            Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(item.isComplete ? .green : .gray)
                        }
                    }
                }
                
                if let notes = item.notes, !notes.isEmpty {
                    Section("Notes") {
                        Text(notes)
                            .font(.body)
                    }
                }
                
                Section {
                    LabeledContent("Type") {
                        Text(item.type ?? "task")
                            .foregroundColor(item.type == "habit" ? .blue : .purple)
                    }
                    
                    LabeledContent("Priority") {
                        HStack(spacing: 2) {
                            ForEach(0..<Int(item.priority), id: \.self) { _ in
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.orange)
                            }
                            if item.priority == 0 {
                                Text("None")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if let dueDate = item.dueDate {
                        LabeledContent("Due Date") {
                            Text(dueDate, style: .date)
                        }
                    }
                    
                    LabeledContent("Created") {
                        Text(item.createdAt ?? Date(), style: .date)
                    }
                    
                    LabeledContent("Last Updated") {
                        Text(item.updatedAt ?? Date(), style: .date)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.deleteItem(item)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        dismiss()
                        onEdit()
                    }
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = HabitViewModel(context: context)
    let item = HabitItem(context: context)
    item.title = "Sample Task"
    item.type = "task"
    item.notes = "This is a detailed description of the task that might contain important information."
    item.priority = 2
    item.dueDate = Date()
    item.createdAt = Date()
    item.updatedAt = Date()
    
    return HabitItemDetailView(
        item: item,
        viewModel: viewModel,
        onEdit: {}
    )
} 