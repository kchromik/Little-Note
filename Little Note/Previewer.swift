//
//  Previewer.swift
//  Little Note
//
//  Created by Kevin Chromik on 09.02.24.
//

import LittleBase
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let note: Note

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Note.self, configurations: config)

        note = Note()
        note.text = "This is a short note"

        container.mainContext.insert(note)
    }
}
