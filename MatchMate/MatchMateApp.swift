//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI
@main
struct MatchMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase{
            case .active:
                NetworkMonitor.shared.startMonitoring()
            case .inactive:
                print(scenePhase)
            case .background:
                NetworkMonitor.shared.stopMonitoring()
            @unknown default:
                print(newScenePhase)
                NetworkMonitor.shared.stopMonitoring()
            }
        }
    }
}
