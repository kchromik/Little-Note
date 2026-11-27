//
//  Little_Note_iOSApp.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Required for CloudKit push notifications that trigger iCloud sync
        application.registerForRemoteNotifications()

        return true
    }

    nonisolated func application(_ application: UIApplication,
                                  didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        // NSPersistentCloudKitContainer processes the notification internally.
        // Returning .newData tells the system we handled it.
        return .newData
    }
}

@main
struct Little_Note_iOSApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let modelContainer: ModelContainer
    let syncMonitor: CloudKitSyncMonitor

    init() {
        let schema = Schema([Note.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            self.modelContainer = container
            self.syncMonitor = CloudKitSyncMonitor(modelContainer: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            NotesScreen()
        }
        .modelContainer(modelContainer)
    }
}
