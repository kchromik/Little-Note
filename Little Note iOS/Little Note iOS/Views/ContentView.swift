//
//  ContentView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.lastUpdated, order: .reverse) var notes: [Note]

    @State private var showingDetails = false
    @State private var currentNote: Note?
    @State private var isEditing = false
    @State private var currentFilter: Filter = .all

    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Filter.allCases, id: \.self) { filter in
                            FilterView(filter: filter, isActive: .constant(currentFilter == filter), numberOfItems: filteredNotes(for: filter).count)
                                .onTapGesture {
                                    withAnimation {
                                        currentFilter = filter
                                    }
                                }
                        }
                    }
                    .padding()
                }

                List {
                    ForEach(filteredNotes) { note in
                        Cell(note: note)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                isEditing = true
                                currentNote = note
                                withAnimation {
                                    showingDetails.toggle()
                                }
                            }
                    }
                    .onDelete(perform: deleteNote)
                }
                .listStyle(.plain)
                .listRowSpacing(0)
                .animation(.default, value: notes)
            }


            VStack {
                Spacer()
                FloatingButtons(showingDetails: $showingDetails)
            }
            .padding(.bottom, 12)
        }
        .sheet(isPresented: $showingDetails, onDismiss: saveCurrentNoteIfNotEmpty) {
            if let note = currentNote {
                DetailView(note: note)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(32)
                    .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: showingDetails) { oldValue, newValue in
            if newValue && !isEditing {
                currentNote = Note()
            }
        }
    }

    private var filteredNotes: [Note] {
        switch currentFilter {
        case .all:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        }
    }

    private func filteredNotes(for filter: Filter) -> [Note] {
        switch filter {
        case .all:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        }
    }

    private func saveCurrentNoteIfNotEmpty() {
        defer {
            currentNote = nil
        }
        guard let currentNote = currentNote, !currentNote.text.isEmpty else {
            return
        }

        // If creating a new note, add it to the model context with animation.
        if !isEditing {
            modelContext.insert(currentNote)
        }

        // Reset editing flag after saving
        isEditing = false
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = notes[index]
            modelContext.delete(noteToDelete)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
