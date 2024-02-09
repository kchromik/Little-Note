//
//  Little_NoteApp.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import SwiftUI
import SwiftData

@main
struct Little_NoteApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
