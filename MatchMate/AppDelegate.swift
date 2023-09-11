//
//  AppDelegate.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 09/09/23.
//

import UIKit
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NetworkMonitor.shared.startMonitoring()
        return true
    }
    
}
