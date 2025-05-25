//
//  HabitusApp.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import SwiftUI

@main
struct HabitusApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
