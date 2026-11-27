//
//  ContentViewModel.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 18.09.24.
//

import Foundation
import SwiftData
import Combine

@Observable
public class ContentViewModel {

    public var modelContext: ModelContext
    public var notes = [Note]()
    public var currentNote: Note?
    public var currentFilter: Filter = .all
    public var showingDetails = false
    public var showingSettings = false
    public var isEditing = false

    private var cancellables = Set<AnyCancellable>()

    public var filteredNotes: [Note] {
        switch currentFilter {
        case .all:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        @unknown default:
            fatalError()
        }
    }

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext

        fetchData()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(remoteStoreDidChange),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: nil)
    }

    @objc private func remoteStoreDidChange(_ notification: Notification) {
        // Fetch the data again when changes are detected
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
            try? modelContext.save()
        }

        isEditing = false
    }

    public func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = notes[index]
            modelContext.delete(noteToDelete)
        }
        try? modelContext.save()
        fetchData()
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
