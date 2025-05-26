import SwiftUI

struct HabitItemRow: View {
    let item: HabitItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    @ObservedObject var viewModel: HabitViewModel
    
    @State private var showingDetail = false
    @State private var showingEditSheet = false
    @State private var isAnimatingToggle = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isAnimatingToggle = true
                    onToggle()
                }
                // Reset animation state after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimatingToggle = false
                }
            }) {
                Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isComplete ? .green : .gray)
                    .scaleEffect(isAnimatingToggle ? 1.2 : 1.0)
            }
            .buttonStyle(.plain)
            
            // Content
            Button(action: { 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showingDetail = true
                }
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title ?? "")
                        .font(.headline)
                        .strikethrough(item.isComplete)
                        .foregroundColor(item.isComplete ? .gray : .primary)
                        .animation(.easeInOut(duration: 0.2), value: item.isComplete)
                    
                    HStack {
                        // Type Badge
                        Text(item.type ?? "task")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(item.type == "habit" ? Color.blue.opacity(0.2) : Color.purple.opacity(0.2))
                            )
                            .foregroundColor(item.type == "habit" ? .blue : .purple)
                            .transition(.scale.combined(with: .opacity))
                        
                        // Priority Indicator
                        if item.priority > 0 {
                            HStack(spacing: 2) {
                                ForEach(0..<Int(item.priority), id: \.self) { index in
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                        .transition(.scale.combined(with: .opacity))
                                        .animation(
                                            .spring(response: 0.3, dampingFraction: 0.7)
                                            .delay(Double(index) * 0.05),
                                            value: item.priority
                                        )
                                }
                            }
                        }
                        
                        // Due Date
                        if let dueDate = item.dueDate {
                            Text(dueDate, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Menu Button
            Menu {
                Button(action: { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingEditSheet = true
                    }
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .sheet(isPresented: $showingDetail) {
            HabitItemDetailView(
                item: item,
                viewModel: viewModel,
                onEdit: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingEditSheet = true
                    }
                }
            )
            .transition(.move(edge: .bottom))
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditItemView(viewModel: viewModel, editingItem: item)
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = HabitViewModel(context: context)
    let item = HabitItem(context: context)
    item.title = "Sample Task"
    item.type = "task"
    item.notes = "This is a sample task with some notes"
    item.priority = 2
    item.dueDate = Date()
    
    return HabitItemRow(
        item: item,
        onToggle: {},
        onDelete: {},
        viewModel: viewModel
    )
    .padding()
} 