//
//  ContentView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import Combine
import LittleBase
import SwiftData
import SwiftUI

struct NotesScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var notes: [Note] = []
    @State var currentNote: Note?
    @State var currentFilter: Filter = .all
    @State var showingDetails = false
    @State var showingSettings = false
    @State var isEditing = false
    @State private var searchText = ""
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    private var isTrash: Bool {
        currentFilter == .trash
    }

    private var filteredNotes: [Note] {
        switch currentFilter {
        case .all, .trash:
            return notes
        case .favorite:
            return notes.filter { $0.isFavourite }
        }
    }

    private func saveCurrentNoteIfNotEmpty() {
        defer {
            currentNote = nil
            fetchNotes()
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

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView
                searchBar
                contentView
            }

            if !isTrash {
                floatingButtonOverlay
            }
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
        .task {
            purgeOldTrash()
            fetchNotes()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)) { _ in
            fetchNotes()
        }
        .onChange(of: currentFilter) {
            fetchNotes()
        }
        .onChange(of: searchText) {
            fetchNotes()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Filter.allCases, id: \.self) { filter in
                        FilterView(
                            filter: filter,
                            isActive: currentFilter == filter
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentFilter = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }

            Button {
                showingSettings.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.regularMaterial)
                    )
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
        }
        .padding(.vertical, 16)
        .background(.regularMaterial)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search notes…", text: $searchText)
                .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var contentView: some View {
        if filteredNotes.isEmpty {
            Spacer()
            EmptyListView(activeFilter: currentFilter)
            Spacer()
        } else if isIPad {
            iPadGridView
        } else {
            iPhoneListView
        }
    }

    private var iPadGridView: some View {
        GridView(
            notes: filteredNotes,
            isTrash: isTrash,
            onNoteTapped: { note in
                guard !isTrash else { return }
                isEditing = true
                currentNote = note
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showingDetails.toggle()
                }
            },
            onNoteDeleted: { note in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    softDelete(note: note)
                }
            },
            onNoteFavoriteToggled: { note in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    note.isFavourite.toggle()
                    try? modelContext.save()
                }
            },
            onNoteColorChanged: { note, color in
                note.color = color.rawValue
                try? modelContext.save()
            },
            onNoteRestored: { note in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    restoreNote(note)
                }
            },
            onNotePermanentlyDeleted: { note in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    permanentlyDelete(note: note)
                }
            }
        )
    }

    private var iPhoneListView: some View {
        List {
            ForEach(filteredNotes) { note in
                noteRow(for: note)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: filteredNotes)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 80)
        }
    }

    private func noteRow(for note: Note) -> some View {
        Button {
            guard !isTrash else { return }
            isEditing = true
            currentNote = note
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showingDetails.toggle()
            }
        } label: {
            Cell(note: note)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if isTrash {
                Button(role: .destructive) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        permanentlyDelete(note: note)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.slash")
                }
            } else {
                Button(role: .destructive) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        softDelete(note: note)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                Menu {
                    ForEach(NoteColor.allCases, id: \.self) { color in
                        Button(color.rawValue.capitalized) {
                            note.color = color.rawValue
                        }
                    }
                } label: {
                    Label("Color", systemImage: "paintpalette")
                }
                .tint(.blue)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if isTrash {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        restoreNote(note)
                    }
                } label: {
                    Label("Restore", systemImage: "arrow.uturn.backward")
                }
                .tint(.green)
            } else {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        note.isFavourite.toggle()
                    }
                } label: {
                    Label(note.isFavourite ? "Unfavorite" : "Favorite",
                          systemImage: note.isFavourite ? "heart.slash.fill" : "heart.fill")
                }
                .tint(.red)
            }
        }
    }

    private var floatingButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingButtons(showingDetails: $showingDetails)
            }
            .padding(.bottom, 12)
            .padding(.trailing, 20)
        }
    }

    private func fetchNotes() {
        do {
            let showDeleted = currentFilter == .trash
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
        note.isDeleted = true
        note.deletedAt = Date()
        try? modelContext.save()
        fetchNotes()
    }

    private func restoreNote(_ note: Note) {
        note.isDeleted = false
        note.deletedAt = nil
        try? modelContext.save()
        fetchNotes()
    }

    private func permanentlyDelete(note: Note) {
        modelContext.delete(note)
        try? modelContext.save()
        fetchNotes()
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
}