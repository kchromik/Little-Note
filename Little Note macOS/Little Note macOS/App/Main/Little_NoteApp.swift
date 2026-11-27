//
//  Little_NoteApp.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import LittleBase
import SwiftUI
import SwiftData
import MenuBarExtraAccess

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Required for CloudKit push notifications that trigger iCloud sync
        NSApplication.shared.registerForRemoteNotifications()
    }

    func application(_ application: NSApplication,
                     didReceiveRemoteNotification userInfo: [String: Any]) {
        // NSPersistentCloudKitContainer processes the notification internally
    }
}

enum WindowSize: String, CaseIterable, Codable {
    case small
    case medium
    case large

    var dimensions: (width: CGFloat, height: CGFloat) {
        switch self {
        case .small:
            return (400, 300)
        case .medium:
            return (520, 400)
        case .large:
            return (700, 550)
        }
    }
}

@main
struct Little_NoteApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var hotKeyViewModel = HotKeyViewModel()
    @AppStorage("windowSize") private var windowSizeRawValue: String = WindowSize.medium.rawValue

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

        _hotKeyViewModel = StateObject(wrappedValue: HotKeyViewModel())
        _windowSizeRawValue = AppStorage(wrappedValue: WindowSize.medium.rawValue, "windowSize")
    }

    var windowSize: WindowSize {
        WindowSize(rawValue: windowSizeRawValue) ?? .medium
    }

    var body: some Scene {
        MenuBarExtra(
            "Little Note", systemImage: "pencil.line")
        {
            NotesScreen(isMenuPresented: $hotKeyViewModel.isMenuPresented)
                .frame(width: windowSize.dimensions.width, height: windowSize.dimensions.height)
                .animation(.default, value: windowSize)
                .modelContainer(modelContainer)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $hotKeyViewModel.isMenuPresented)
    }
}
