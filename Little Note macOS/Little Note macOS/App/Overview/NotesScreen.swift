//
//  ContentView.swift
//  Little Note
//
//  Created by Kevin Chromik on 01.08.23.
//

import Combine
import SwiftUI
import SwiftData
import AppKit
import HotKey
import LittleBase

struct NotesScreen: View {

    @Binding var isMenuPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @State private var notes: [Note] = []
    @State private var currentNoteID: Note.ID?
    @State private var showSettings = false
    @State private var showNoteInfo = false
    @State private var showCopiedMessage = false
    @State private var searchText = ""
    @State private var showTrash = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedFont") var selectedFont: AvailableFonts = .system
    @AppStorage("fontSize") var fontSize: Int = 14
    @State var windowsController: WindowsController = .init()
    @State private var currentNote: Note = Note()

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack {
                    // Search field
                    HStack(spacing: 4) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        TextField("Search", text: $searchText)
                            .textFieldStyle(.plain)
                            .font(.caption)
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)

                    ScrollView(.vertical) {

                        ForEach(notes, id: \.id) { note in
                            Text(note.title.isEmpty ? "Note" : note.title)
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(note.title.isEmpty ? 0.6 : 1.0)
                                .frame(width: 80)
                                .lineLimit(1)
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    currentNoteID == note.id
                                    ? (NoteColor(rawValue: note.color)?.color ?? .yellow)
                                    : ((NoteColor(rawValue: note.color)?.color ?? .yellow).opacity(0.6))
                                )
                                .cornerRadius(4)
                                .onTapGesture {
                                    switchCurrentNoteTo(note)
                                }
                                .contextMenu {
                                    if showTrash {
                                        Button {
                                            withAnimation {
                                                restoreNote(note)
                                            }
                                        } label: {
                                            Label("Restore", systemImage: "arrow.uturn.backward")
                                        }

                                        Button(role: .destructive) {
                                            withAnimation {
                                                permanentlyDelete(note: note)
                                            }
                                        } label: {
                                            Label("Delete Permanently", systemImage: "trash.slash")
                                        }
                                    } else {
                                        Menu("Color") {
                                            ForEach(NoteColor.allCases, id: \.self) { color in
                                                Button {
                                                    note.color = color.rawValue
                                                    try? modelContext.save()
                                                } label: {
                                                    Label(color.rawValue.capitalized, systemImage: note.color == color.rawValue ? "checkmark.circle.fill" : "circle.fill")
                                                }
                                            }
                                        }

                                        Divider()

                                        if notes.count > 1 {
                                            Button(role: .destructive, action: {
                                                withAnimation {
                                                    softDelete(note: note)
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                        }
                        .padding(.leading, 8)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top)

                    HStack {
                        Button {
                            withAnimation {
                                showTrash.toggle()
                                fetchNotes()
                            }
                        } label: {
                            Image(systemName: showTrash ? "tray.full.fill" : "trash")
                                .foregroundStyle(showTrash ? .red : .secondary)
                        }
                        .buttonStyle(.plain)
                        .help(showTrash ? "Back to notes" : "Trash")

                        if !showTrash {
                            Button {
                                withAnimation {
                                    _ = addNewNote()
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .keyboardShortcut("n")
                        }
                    }
                    .padding(.bottom, 4)
                }
                .frame(width: 110)

                VStack {
                    VStack {
                        TextField("Note title", text: bindingForTitle())
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(selectedFont.activeFont(with: fontSize + 2))
                            .bold()
                            .padding([.horizontal, .top])
                            .padding(.leading, 4)
                            .disabled(showTrash)

                        TextPad(note: currentNote, isMenuPresented: $isMenuPresented)
                            .padding([.horizontal, .bottom])
                            .disabled(showTrash)
                            .opacity(showTrash ? 0.6 : 1.0)

                        HStack {
                            HoverButton(imageName: "exclamationmark.square") {
                                showNoteInfo.toggle()
                            }
                            .popover(isPresented: $showNoteInfo) {
                                AnalyticsView(note: currentNote)
                            }
                            .help("Info")

                            HoverButton(imageName: "arrow.up.backward.and.arrow.down.forward.square") {
                                let textPad = TextPad(note: currentNote, isMenuPresented: .constant(false))
                                    .frame(minWidth: 480, minHeight: 400)
                                    .padding()

                                windowsController
                                    .show(view: textPad, for: currentNote.id)
                            }
                            .help("Open in window")

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
                }
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
        .task {
            purgeOldTrash()
            fetchNotes()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)) { _ in
            fetchNotes()
        }
        .onChange(of: searchText) {
            fetchNotes()
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

    private func bindingForTitle() -> Binding<String> {
        Binding<String>(
            get: { currentNote.customTitle },
            set: { newValue in
                currentNote.lastUpdated = Date()
                currentNote.customTitle = newValue
            }
        )
    }

    private func fetchNotes() {
        do {
            let showDeleted = showTrash
            let searchTerm = searchText.trimmingCharacters(in: .whitespaces)
            var descriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)])

            if searchTerm.isEmpty {
                descriptor.predicate = #Predicate<Note> { note in
                    note.isDeleted == showDeleted
                }
            } else {
                descriptor.predicate = #Predicate<Note> { note in
                    note.isDeleted == showDeleted &&
                    (note.text.localizedStandardContains(searchTerm) ||
                     note.customTitle.localizedStandardContains(searchTerm))
                }
            }

            notes = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }

    private func softDelete(note: Note) {
        let index = notes.firstIndex(where: { $0.id == note.id })

        note.isDeleted = true
        note.deletedAt = Date()
        try? modelContext.save()
        fetchNotes()

        selectNextNote(afterRemovingAt: index)
    }

    private func restoreNote(_ note: Note) {
        let index = notes.firstIndex(where: { $0.id == note.id })

        note.isDeleted = false
        note.deletedAt = nil
        try? modelContext.save()
        fetchNotes()

        selectNextNote(afterRemovingAt: index)
    }

    private func permanentlyDelete(note: Note) {
        let index = notes.firstIndex(where: { $0.id == note.id })

        modelContext.delete(note)
        try? modelContext.save()
        fetchNotes()

        selectNextNote(afterRemovingAt: index)
    }

    private func selectNextNote(afterRemovingAt index: Int?) {
        if let index = index {
            let newNoteIndex = index == 0 ? 0 : index - 1
            if !notes.isEmpty {
                DispatchQueue.main.async {
                    if newNoteIndex < self.notes.count {
                        self.currentNoteID = self.notes[newNoteIndex].id
                    } else {
                        self.currentNoteID = self.notes.first?.id
                    }
                }
            } else if !showTrash {
                DispatchQueue.main.async {
                    _ = self.addNewNote()
                }
            }
        } else if notes.isEmpty && !showTrash {
            DispatchQueue.main.async {
                _ = self.addNewNote()
            }
        }
    }

    private func purgeOldTrash() {
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let descriptor = FetchDescriptor<Note>(predicate: #Predicate<Note> { note in
            note.isDeleted == true && note.deletedAt != nil && note.deletedAt! < cutoff
        })
        if let old = try? modelContext.fetch(descriptor), !old.isEmpty {
            for note in old { modelContext.delete(note) }
            try? modelContext.save()
        }
    }

    private func switchCurrentNoteTo(_ note: Note) {
        // Save current note before switching to ensure CloudKit picks up changes
        try? modelContext.save()

        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Soft-delete the current note if it's empty before switching
            softDelete(note: currentNote)
        }
        currentNoteID = note.id
    }

    private func addNewNote() -> Note {
        if let currentNote = notes.first(where: { $0.id == currentNoteID }), currentNote.text.isEmpty {
            // Permanently delete empty note (no need to trash it)
            modelContext.delete(currentNote)
            try? modelContext.save()
        }
        let newNote = Note()
        modelContext.insert(newNote)
        try? modelContext.save()
        fetchNotes()
        currentNoteID = newNote.id
        return newNote
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NotesScreen(isMenuPresented: .constant(false))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
