//
//  InternetConnectionManager.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 09/09/23.
//

import Foundation
import Network
class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            if path.status == .satisfied {
                // post connected notification
                DatabaseManager.shared.syncDataToServer { result in
                    switch result {
                    case .success:
                        print("Data synchronization successful.")
                    case .failure(let error):
                        print("Data synchronization failed: \(error)")
                    }
                }
            } else {
                print("No connection.")
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
