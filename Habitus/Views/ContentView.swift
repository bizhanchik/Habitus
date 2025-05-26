import SwiftUI
import CoreData

// MARK: - Filter Picker View
private struct FilterPickerView: View {
    @Binding var selectedFilter: HabitViewModel.ItemFilter
    let onFilterChange: (HabitViewModel.ItemFilter) -> Void
    
    var body: some View {
        Picker("Filter", selection: $selectedFilter) {
            Text("All").tag(HabitViewModel.ItemFilter.all)
            Text("Tasks").tag(HabitViewModel.ItemFilter.tasks)
            Text("Habits").tag(HabitViewModel.ItemFilter.habits)
            Text("Completed").tag(HabitViewModel.ItemFilter.completed)
            Text("Incomplete").tag(HabitViewModel.ItemFilter.incomplete)
        }
        .pickerStyle(.segmented)
        .frame(width: 200)
        .onChange(of: selectedFilter) { newFilter in
            onFilterChange(newFilter)
        }
    }
}

// MARK: - Item List View
private struct ItemListView: View {
    let items: [HabitItem]
    let viewModel: HabitViewModel
    let isFirstAppear: Bool
    
    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                HabitItemRow(
                    item: item,
                    onToggle: { viewModel.toggleCompletion(for: item) },
                    onDelete: { viewModel.deleteItem(item) },
                    viewModel: viewModel
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .opacity(isFirstAppear ? 0 : 1)
                .offset(x: isFirstAppear ? 50 : 0)
                .animation(
                    .easeOut(duration: 0.5)
                    .delay(Double(index) * 0.05),
                    value: isFirstAppear
                )
            }
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: items)
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var viewModel: HabitViewModel
    @State private var showingAddSheet = false
    @State private var selectedFilter: HabitViewModel.ItemFilter = .all
    @State private var isFirstAppear = true
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.items.isEmpty {
                    EmptyStateView(
                        title: "No Items",
                        message: "Start by adding your first task or habit to begin tracking your progress.",
                        buttonTitle: "Add New Item",
                        action: { showingAddSheet = true }
                    )
                    .transition(.opacity.combined(with: .scale))
                } else {
                    ItemListView(
                        items: viewModel.items,
                        viewModel: viewModel,
                        isFirstAppear: isFirstAppear
                    )
                }
            }
            .navigationTitle("Habitus")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    FilterPickerView(
                        selectedFilter: $selectedFilter,
                        onFilterChange: { newFilter in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.setFilter(newFilter)
                            }
                        }
                    )
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditItemView(viewModel: viewModel)
                    .transition(.move(edge: .bottom))
            }
            .onAppear {
                // Trigger the staggered animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isFirstAppear = false
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }
}

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

