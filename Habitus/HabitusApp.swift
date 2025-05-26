//
//  HabitusApp.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

/*
 MVVM Architecture
 
 Model - data point
 View - UI
 ViewModel - manage Models for View
 
 */

import SwiftUI

@main
struct HabitusApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
