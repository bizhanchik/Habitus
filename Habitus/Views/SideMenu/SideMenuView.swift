//
//  SideMenuView.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import SwiftUI



struct SideMenuView: View {
    
    @Binding var isShowing: Bool
    @Binding var selectedTab: Int
    @State private var selectedOption: SideMenuOptionModel?
    
    
    
    var body: some View {
        ZStack{
            if isShowing{
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                HStack{
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView()
                        
                        VStack{
                            ForEach(SideMenuOptionModel.allCases) {option in
                                Button {
                                    selectedOption = option
                                    selectedTab = option.rawValue
                                } label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                }

                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                    Spacer()
                }
                
                
                
                
                Spacer()
            }
        }
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenuHeaderView: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("Habitus")
                    .font(.system(size: 32, weight: .bold, design: .default))
                
                
            }
            
            HStack{
                Image(systemName: "person.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bizhan Ashykhatov")
                        .font(.subheadline)
                    
                    Text("example@example.com")
                        .font(.footnote)
                        .tint(.gray)
                }
            }
        }
    }
}



#Preview {
    SideMenuView(isShowing: .constant(true), selectedTab: .constant(0))
}

