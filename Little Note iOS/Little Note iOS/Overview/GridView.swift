
//
//  GridView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftUI

struct GridView: View {
    let notes: [Note]
    var isTrash: Bool = false
    let onNoteTapped: (Note) -> Void
    let onNoteDeleted: ((Note) -> Void)?
    let onNoteFavoriteToggled: ((Note) -> Void)?
    let onNoteColorChanged: ((Note, NoteColor) -> Void)?
    var onNoteRestored: ((Note) -> Void)?
    var onNotePermanentlyDeleted: ((Note) -> Void)?

    private let columns = [
        GridItem(.adaptive(minimum: 250), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(notes) { note in
                    Button(action: { onNoteTapped(note) }) {
                        Cell(note: note)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        if isTrash {
                            Button {
                                onNoteRestored?(note)
                            } label: {
                                Label("Restore", systemImage: "arrow.uturn.backward")
                            }

                            Button(role: .destructive) {
                                onNotePermanentlyDeleted?(note)
                            } label: {
                                Label("Delete Permanently", systemImage: "trash.slash")
                            }
                        } else {
                            Button {
                                onNoteFavoriteToggled?(note)
                            } label: {
                                Label(note.isFavourite ? "Unfavorite" : "Favorite",
                                      systemImage: note.isFavourite ? "heart.slash" : "heart.fill")
                            }

                            Menu {
                                ForEach(NoteColor.allCases, id: \.self) { color in
                                    Button(color.rawValue.capitalized) {
                                        onNoteColorChanged?(note, color)
                                    }
                                }
                            } label: {
                                Label("Color", systemImage: "paintpalette")
                            }

                            Divider()

                            Button(role: .destructive) {
                                onNoteDeleted?(note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) // Extra padding to avoid floating button overlap
        }
    }
}
