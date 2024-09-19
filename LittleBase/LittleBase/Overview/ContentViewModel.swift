//
//  ContentViewModel.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 18.09.24.
//

import Foundation
import SwiftData

@Observable
public class ContentViewModel {

    public var modelContext: ModelContext
    public var notes = [Note]()
    public var currentNote: Note?
    public var currentFilter: Filter = .all
    public var showingDetails = false
    public var showingSettings = false
    public var isEditing = false

    public var filteredNotes: [Note] {
        switch currentFilter {
        case .all:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        }
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext

        fetchData()
    }

    public func saveCurrentNoteIfNotEmpty() {
        defer {
            currentNote = nil
            fetchData()
        }
        guard let currentNote = currentNote, !currentNote.text.isEmpty else {
            return
        }

        if !isEditing {
            modelContext.insert(currentNote)
        }

        isEditing = false
    }

    public func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = notes[index]
            modelContext.delete(noteToDelete)
        }
    }

    private func fetchData() {
        do {
            let descriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)])
            notes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
