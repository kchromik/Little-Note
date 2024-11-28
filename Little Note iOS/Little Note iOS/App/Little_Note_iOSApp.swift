//
//  Little_Note_iOSApp.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI
import WishKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        WishKit.configure(with: "5D1641BE-1F4B-4167-84E6-F5A32074B842")
        WishKit.config.allowUndoVote = true
        return true
    }
}

@main
struct Little_Note_iOSApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NotesScreen()
        }
        .modelContainer(for: [Note.self])
    }
}
