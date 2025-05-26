import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.green.opacity(0.8))
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: action) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text(buttonTitle)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        title: "No Tasks Yet",
        message: "Start by adding your first task or habit to begin tracking your progress.",
        buttonTitle: "Add New Item",
        action: {}
    )
}

