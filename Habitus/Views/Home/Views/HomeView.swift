//
//  HomeView.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var animate: Bool = false
    @State private var showMenu: Bool = false
    @State private var selectedTab: Int = 0
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Welcome to Habitus")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 70)
                        .background(animate ? Color.primary : Color.clear)
                        .cornerRadius(20)
                        .offset(x: animate ? 0 : -300)
                        .animation(.easeInOut(duration: 1.0), value: animate)
                        .padding(.top, 10)
                        .onAppear {
                            addAnimation()
                        }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            
            SideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)
        }
        .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .opacity(animate ? 1 : 0)
                        .offset(x: animate ? 0 : -100)
                        .animation(.easeInOut(duration: 1.0), value: animate)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Home")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .opacity(animate ? 1 : 0)
                    .offset(x: animate ? 0 : -100)
                    .animation(.easeInOut(duration: 1.0), value: animate)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
            ) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
