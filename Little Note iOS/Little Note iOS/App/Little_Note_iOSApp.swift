//
//  Little_Note_iOSApp.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI

@main
struct Little_Note_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Note.self)
        }
    }
}
