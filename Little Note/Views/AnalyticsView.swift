//
//  AnalyticsView.swift
//  Little Note
//
//  Created by Kevin Chromik on 24.05.24.
//

import SwiftUI

struct AnalyticsView: View {

    let note: Note

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Text("# of words")
                Spacer()
                Text("\(note.numberOfWords)")
            }
            HStack {
                Text("Created at")
                Spacer()
                Text("\(note.formattedCreatedAtDate)")
            }

            HStack {
                Text("Last updated at")
                Spacer()
                Text("\(note.formattedLastUpdatedDate)")
            }
        }
        .padding()
    }
}

#Preview {

    let note = Note()
    note.text = "hallo fdf"
    return AnalyticsView(note: note)
}
