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

@main
struct Little_NoteApp: App {

    @StateObject var hotKeyViewModel = HotKeyViewModel()

    var body: some Scene {
        MenuBarExtra(
            "Little Note", systemImage: "pencil.line")
        {
            NotesScreen()
                .frame(width: 520, height: 400)
                .modelContainer(for: Note.self)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $hotKeyViewModel.isMenuPresented)
    }
}
