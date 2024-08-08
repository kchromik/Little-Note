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

    var body: some View {
        List {
            ForEach(notes) { note in
                Text(note.formattedCreatedAtDate)
            }
        }
    }
}

#Preview {
    ContentView()
}
