//
//  ContentView.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import SwiftUI
import SwiftData
import AppKit
import HotKey

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.lastUpdated, order: .reverse) var notes: [Note]
    @State private var currentNoteID: Note.ID?
    @State private var showSettings = false
    @Environment(\.colorScheme) var colorScheme

    private var currentNote: Note {
        if let id = currentNoteID, let note = notes.first(where: { $0.id == id }) {
            return note
        } else {
            return notes.first ?? Note()
        }
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(notes, id: \.id) { note in
                        Text(note.title.isEmpty ? "Note" : note.title)
                            .font(.footnote)
                            .opacity(note.title.isEmpty ? 0.6 : 1.0)
                            .frame(width: 40)
                            .lineLimit(1)
                            .foregroundColor(currentNoteID == note.id ? .white : .black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(currentNoteID == note.id ? .blue : Color.teal)
                            .cornerRadius(20)
                            .onTapGesture {
                                switchCurrentNoteTo(note)
                            }
                            .contextMenu {
                                if notes.count > 1 {
                                    Button(action: {
                                        withAnimation {
                                            delete(note: note)
                                        }
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                    }

                    Button {
                        withAnimation {
                            addNewNote()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .keyboardShortcut("n")

                    Spacer()
                }
                .padding([.leading, .trailing])
            }
            .scrollIndicators(.hidden)
            .padding([.top])
            TextPad(note: currentNote)
                .padding()
            HStack {
                Text("Last updated at \(currentNote.formattedLastUpdatedDate)")

                Spacer()

                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(currentNote.text, forType: .string)
                } label: {
                    Image(systemName: "clipboard")
                }
                .buttonStyle(.plain)

                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showSettings) {
                    SettingsView()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
        }
        .onAppear {
            if notes.isEmpty {
                addNewNote()
            } else {
                currentNoteID = notes.first?.id
            }
        }
    }

    private func delete(note: Note) {
        modelContext.delete(note)
        // Adjust the logic to ensure a new current note is selected if the current note was deleted
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            let newNoteIndex = index == 0 ? (notes.count > 1 ? 1 : 0) : index - 1
            currentNoteID = notes.indices.contains(newNoteIndex) ? notes[newNoteIndex].id : nil
        }
        // Create and select a new note if no other notes are left
        if notes.isEmpty {
            addNewNote()
        }
    }

    private func switchCurrentNoteTo(_ note: Note) {
        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Delete the current note if it's empty before switching
            delete(note: currentNote)
        }
        currentNoteID = note.id
    }

    private func addNewNote() {
        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Delete the current empty note before adding a new one
            delete(note: currentNote)
        }
        let newNote = Note()
        modelContext.insert(newNote)
        currentNoteID = newNote.id
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
