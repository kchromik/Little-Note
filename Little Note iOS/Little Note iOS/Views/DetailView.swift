//
//  DetailView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import HighlightedTextEditor
import LittleBase
import SwiftUI

struct DetailView: View {

    @Environment(\.dismiss) var dismiss

    @Bindable var note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(note.formattedCreatedAtDate)
                .foregroundStyle(Color(red: 172.0/255.0, green: 142.0/255.0, blue: 34.0/255.0))
                .font(.headline)

            TextField("Enter title", text: $note.customTitle)
                .font(.title)
                .foregroundStyle(.black)

            TextEditor(text: $note.text)
                .font(.body)
                .foregroundStyle(.black)
                .scrollContentBackground(.hidden)

            HStack {
                Text("\(note.numberOfWords) words")
                    .font(.footnote)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(Color(red: 227.0/255.0, green: 211.0/255.0, blue: 64.0/255.0))
                    .cornerRadius(12)

                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Note Detail")
        .background(Color(red: 235.0/255.0, green: 223.0/255.0, blue: 75.0/255.0))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: .gray.opacity(0.4), radius: 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
