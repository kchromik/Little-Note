//
//  Little_NoteApp.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import SwiftUI
import SwiftData
import HotKey

@main
struct Little_NoteApp: App {

    private let hotkey = HotKey(key: .o, modifiers: [.control, .option, .command])
    @AppStorage("hotkeyEnabled") var hotkeyEnabled: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
