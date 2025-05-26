//
//  SideMenuOptionModel.swift
//  Habitus
//
//  Created by Bizhan Ashykhatov on 25.05.2025.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case home
    case todo
    case notes
    case habits
    case stats
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .todo:
            return "To-Do"
        case .notes:
            return "Notes"
        case .habits:
            return "Habits"
        case .stats:
            return "Stats"
        }
    }
    
    var systemImageName: String{
        switch self {
        case .home:
            return "house"
        case .todo:
            return "checklist"
        case .notes:
            return "note.text"
        case .habits:
            return "leaf.fill"
        case .stats:
            return "chart.bar.fill"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id: Int {return self.rawValue}
}
