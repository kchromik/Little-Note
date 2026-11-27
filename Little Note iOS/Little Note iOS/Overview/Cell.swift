//
//  Cell.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftUI

import LittleBase
import SwiftUI

struct Cell: View {

    @Bindable var note: Note
    @Environment(\.colorScheme) var colorScheme

    private var noteColor: Color {
        guard let noteColor = NoteColor(rawValue: note.color) else {
            return .yellow.opacity(0.8)
        }
        return noteColor.color.opacity(0.8)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(note.title)
                .foregroundStyle(.black)
                .font(.headline)
                .lineLimit(2)

            if !note.text.isEmpty {
                Text(note.text)
                    .foregroundStyle(.black)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }

            Spacer()

            HStack {
                Text(note.formattedCreatedAtDate)
                    .foregroundStyle(.black.opacity(0.7))
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Spacer()

                if note.isFavourite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(noteColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
        do {
            let previewer = try Previewer()

            return Cell(note: Note(title: "this is a title", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."))
                .modelContainer(previewer.container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
}
