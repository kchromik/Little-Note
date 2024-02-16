//
//  Little_NoteApp.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import SwiftUI
import SwiftData
import MenuBarExtraAccess

@main
struct Little_NoteApp: App {

    @StateObject var hotKeyViewModel = HotKeyViewModel()

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
        .menuBarExtraAccess(isPresented: $hotKeyViewModel.isMenuPresented)
    }
}
