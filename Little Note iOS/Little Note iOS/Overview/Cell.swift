//
//  Cell.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftUI

struct Cell: View {

    @Bindable var note: Note

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Image(systemName: note.isFavourite ? "heart.fill" : "heart")
                        .symbolEffect(.bounce, value: note.isFavourite)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(8)
                        .onTapGesture {
                            withAnimation {
                                note.isFavourite.toggle()
                            }
                        }
                    Spacer()
                }
            }

            VStack(alignment: .leading) {
                Text(note.formattedCreatedAtDate)
                    .foregroundStyle(Color(red: 172.0/255.0, green: 142.0/255.0, blue: 34.0/255.0))
                    .font(.footnote)
                Text(note.title)
                    .foregroundStyle(.black)
                    .lineLimit(3)
                HStack {
                    Text(note.formattedNumberOfWords)
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .padding(8)
                        .background(Color(red: 227.0/255.0, green: 211.0/255.0, blue: 64.0/255.0))
                        .cornerRadius(12)

                    Spacer()
                }
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                withAnimation {
                    note.isFavourite.toggle()
                }
            } label: {
                Image(systemName: note.isFavourite ? "heart.fill" : "heart")
                    .frame(width: 44, height: 44)
                    .foregroundColor(.black)
                    .tint(.green)
            }
        }
        .padding()
        .background(Color(red: 235.0/255.0, green: 223.0/255.0, blue: 75.0/255.0))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.25), radius: 2,y: 4)
        .onTapGesture(count: 2) {
            withAnimation {
                note.isFavourite.toggle()
            }
        }
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
