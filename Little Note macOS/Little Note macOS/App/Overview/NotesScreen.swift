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
import LittleBase

struct NotesScreen: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.lastUpdated, order: .reverse) var notes: [Note]
    @State private var currentNoteID: Note.ID?
    @State private var showSettings = false
    @State private var showNoteInfo = false
    @State private var showCopiedMessage = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("usesLargeFont") var usesLargeFont: Bool = false

    @State private var currentNote: Note = Note()

    var body: some View {
        ZStack {
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
                                _ = addNewNote()
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
                .padding(.top)
                TextField("Note title", text: $currentNote.customTitle)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: usesLargeFont ? 20 : 16, weight: .bold, design: .rounded))
                    .padding([.horizontal, .top])
                TextPad(note: currentNote)
                    .padding()
                HStack {
                    HoverButton(imageName: "exclamationmark.square") {
                        showNoteInfo.toggle()
                    }
                    .popover(isPresented: $showNoteInfo) {
                        AnalyticsView(note: currentNote)
                    }
                    .help("Info")

                    Spacer()

                    HoverButton(imageName: "document.on.document") {
                        guard let text = NSPasteboard.general.string(forType: .string) else { return }
                        let note = addNewNote()
                        note.text = text
                    }
                    .keyboardShortcut("m")
                    .help("New note from clipboard")

                    HoverButton(imageName: "clipboard") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(currentNote.text, forType: .string)
                        guard !showCopiedMessage else { return }
                        withAnimation {
                            showCopiedMessage = true
                        }

                        // Hide the copied message after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCopiedMessage = false
                            }
                        }

                    }
                    .help("Copy to clipboard")

                    HoverButton(imageName: "gear.circle") {
                        showSettings.toggle()
                    }
                    .popover(isPresented: $showSettings) {
                        SettingsView()
                    }
                    .help("Settings")

                    Button {
                        NSApplication.shared.terminate(self)
                    } label: {
                        Image(systemName: "power")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .help("Shutdown")
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
            }

            if showCopiedMessage {
                VStack {
                    Spacer()
                    Text("Copied to clipboard")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .zIndex(1)
                }
            }
        }
        .onAppear {
            if notes.isEmpty {
                _ = addNewNote()
            } else {
                currentNoteID = notes.first?.id
            }
        }
        .onChange(of: currentNoteID) {
            if let id = currentNoteID, let note = notes.first(where: { $0.id == id }) {
                currentNote = note
            } else {
                currentNote = notes.first ?? Note()
            }
        }
    }

    private func delete(note: Note) {
        modelContext.delete(note)
        try? modelContext.save()
        // Adjust the logic to ensure a new current note is selected if the current note was deleted
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            let newNoteIndex = index == 0 ? (notes.count > 1 ? 1 : 0) : index - 1
            currentNoteID = notes.indices.contains(newNoteIndex) ? notes[newNoteIndex].id : nil
        }
        // Create and select a new note if no other notes are left
        if notes.isEmpty {
            _ = addNewNote()
        }
    }

    private func switchCurrentNoteTo(_ note: Note) {
        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Delete the current note if it's empty before switching
            delete(note: currentNote)
        }
        currentNoteID = note.id
    }

    private func addNewNote() -> Note {
        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Delete the current empty note before adding a new one
            delete(note: currentNote)
        }
        let newNote = Note()
        modelContext.insert(newNote)
        try? modelContext.save()
        currentNoteID = newNote.id
        return newNote
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
