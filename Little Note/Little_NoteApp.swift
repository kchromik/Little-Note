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

    private let hotkey = HotKey(key: .l, modifiers: [.control, .option, .command])
    @AppStorage("hotkeyEnabled") var hotkeyEnabled: Bool = true

//    init() {
//        hotkey.keyDownHandler = { _ in
//            guard hotkeyEnabled else { return }
//            showMenuBarExtra.toggle()
//        }
//    }

    var body: some Scene {
        MenuBarExtra(
            "Little Note", systemImage: "pencil.line")
        {
            ContentView()
                .frame(
                    minWidth: 400, maxWidth: 400,
                    minHeight: 120, maxHeight: 400)
                .modelContainer(for: Note.self)
        }
        .windowResizability(.contentSize)
        .menuBarExtraStyle(.window)
    }
}
