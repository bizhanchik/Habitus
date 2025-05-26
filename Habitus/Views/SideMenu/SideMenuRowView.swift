//
//  SideMenuRowView.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import SwiftUI

struct SideMenuRowView: View {
    let option: SideMenuOptionModel
    @Binding var selectedOption : SideMenuOptionModel?
    
    private var isSelected: Bool {
        return selectedOption == option
    }
    
    var body: some View {
        HStack {
            Image(systemName: option.systemImageName)
                .imageScale(.small)
            
            Text(option.title)
                .font(.subheadline)
            Spacer()
        }
        .padding(.leading)
        .foregroundStyle(isSelected ? .black : .primary)
        .frame(width: 216,height: 44)
        .background(isSelected ? .black.opacity(0.25) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SideMenuRowView(option: .todo, selectedOption: .constant(.todo))
}
