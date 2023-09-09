//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI
import UIKit
@main
struct MatchMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
