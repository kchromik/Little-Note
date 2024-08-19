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
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(notes, id: \.self) { note in
                        Cell(note: note)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteNote)
                }
                .listStyle(.plain)

                VStack {
                    Spacer()
                    FloatingButtons()
                }
            }
            .navigationTitle("My Notes")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
