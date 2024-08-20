//
//  Cell.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftUI

struct Cell: View {

    @State private var showingDetails = false
    let note: Note

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.formattedCreatedAtDate)
                .foregroundStyle(Color(red: 172.0/255.0, green: 142.0/255.0, blue: 34.0/255.0))
                .font(.footnote)
            Text(note.text)
                .foregroundStyle(.black)
                .lineLimit(3)
            HStack {
                Text("\(note.numberOfWords) words")
                    .font(.footnote)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(Color(red: 227.0/255.0, green: 211.0/255.0, blue: 64.0/255.0))
                    .cornerRadius(12)

                Spacer()
            }
        }
        .onTapGesture {
            showingDetails.toggle()
        }
        .sheet(isPresented: $showingDetails) {
            DetailView(note: note)
        }
        .padding()
        .background(Color(red: 235.0/255.0, green: 223.0/255.0, blue: 75.0/255.0))
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: .gray.opacity(0.4), radius: 4)
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

    return Cell(note: Note(with: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."))
}
