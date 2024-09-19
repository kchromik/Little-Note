//
//  Little_Note_iOSApp.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct Little_Note_iOSApp: App {

    private let container: ModelContainer
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        do {
            container = try ModelContainer(for: Note.self)
        } catch {
            fatalError("Failed to create ModelContainer for Note. Error: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .modelContainer(container)
        }
    }
}
