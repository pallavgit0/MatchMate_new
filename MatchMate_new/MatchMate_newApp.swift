//
//  MatchMate_newApp.swift
//  MatchMate_new
//
//  Created by B0288802 on 15/09/24.
//

import SwiftUI

@main
struct MatchMate_newApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
