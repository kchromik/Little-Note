//
//  ContentView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI

struct NotesScreen: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.lastUpdated, order: .reverse) var notes: [Note]
    @State var currentNote: Note?
    @State var currentFilter: Filter = .all
    @State var showingDetails = false
    @State var showingSettings = false
    @State var isEditing = false

    private var filteredNotes: [Note] {
        switch currentFilter {
        case .all:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        @unknown default:
            fatalError()
        }
    }

    var body: some View {
        ZStack {
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

                Spacer()

                if filteredNotes.isEmpty {
                    EmptyListView(activeFilter: currentFilter)
                } else {
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
                            .listRowInsets(.init(top: 8, leading: 8, bottom: 12, trailing: 8))
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

    private func saveCurrentNoteIfNotEmpty() {
        defer {
            currentNote = nil
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

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = notes[index]
            modelContext.delete(noteToDelete)
        }
        try? modelContext.save()
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NotesScreen()
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
        @unknown default:
            fatalError()
        }
    }
}
