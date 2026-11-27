//
//  DetailView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftUI

struct DetailView: View {

    enum FocusedField {
        case title, description
    }

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var note: Note
    @FocusState private var focusedField: FocusedField?

    private var noteColor: Color {
        guard let noteColor = NoteColor(rawValue: note.color) else {
            return Color(red: 1.0, green: 0.9, blue: 0.4)
        }
        return noteColor.color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(note.formattedCreatedAtDate)
                .foregroundStyle(.black.opacity(0.5))
                .font(.headline)

            TextField("",
                      text: $note.customTitle,
                      prompt: Text("Enter title")
                .foregroundColor(Color.black.opacity(0.5))
            )
            .font(.title)
            .foregroundStyle(.black)
            .focused($focusedField, equals: .title)

            ZStack {
                TextEditor(text: $note.text)
                    .font(.body)
                    .foregroundStyle(.black)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: .description)

                if note.text.isEmpty {
                    VStack {
                        HStack {
                            Text("your note comes here...")
                                .foregroundColor(Color.black.opacity(0.5))
                                .padding(.top, 8)

                            Spacer()
                        }

                        Spacer()
                    }
                    .padding(.leading, 4)
                }
            }

            HStack {
                Text("\(note.numberOfWords) words")
                    .font(.footnote)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(noteColor)
                    .cornerRadius(12)

                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Note Detail")
        .background(noteColor)
        .onAppear {
            if note.title.isEmpty {
                focusedField = .title
            }
        }
        .onChange(of: note.text) { _, _ in
            note.lastUpdated = Date()
        }
        .onChange(of: note.customTitle) { _, _ in
            note.lastUpdated = Date()
        }
        .onDisappear {
            do {
                try modelContext.save()
            } catch {
                print("Failed to save note on dismiss: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    do {
        let previewer = try Previewer()

        return DetailView(note: Note(title: "this is a title", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
