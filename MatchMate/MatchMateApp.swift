//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI

@main
struct MatchMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
