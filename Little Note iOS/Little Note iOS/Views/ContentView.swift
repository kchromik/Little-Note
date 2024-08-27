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
    @State private var showingSettings = false
    @State private var currentNote: Note?
    @State private var isEditing = false
    @State private var currentFilter: Filter = .all

    var body: some View {
        ZStack {
            if notes.isEmpty {
                EmptyListView()
            } else {
                VStack(spacing: 0) {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Filter.allCases, id: \.self) { filter in
                                    FilterView(
                                        filter: filter,
                                        isActive: currentFilter == filter
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            currentFilter = filter
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        Spacer()

                        Button {
                            showingSettings.toggle()
                        } label: {
                            Image(systemName: "gear")
                                .tint(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .fill(Color.black)
                                )
                        }
                        .padding(.trailing, 20)
                    }

//                    Color.red
//                        .frame(height: 20)

                    List {
                        ForEach(filteredNotes) { note in
                            Button {
                                isEditing = true
                                currentNote = note
                                withAnimation {
                                    showingDetails.toggle()
                                }
                            } label: {
                                Cell(note: note)
                            }
                            .buttonStyle(ScalableButtonStyle())
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteNote)

                    }
                    .listStyle(.plain)
                    .listRowSpacing(0)
                    .animation(.default, value: filteredNotes)

                }
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
        .fullScreenCover(isPresented: $showingSettings) {
            SettingsView()
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

extension [Note] {

    func filteredNotes(for filter: Filter) -> [Note] {
        switch filter {
        case .all:
            return self
        case .favorite:
            return self.filter { $0.isFavourite }
        }
    }
}
