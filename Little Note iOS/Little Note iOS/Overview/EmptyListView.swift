//
//  EmptyListView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import LittleBase
import SwiftUI

struct EmptyListView: View {

    @State var activeFilter: Filter = .all

    var body: some View {
        VStack {
            Spacer()
            Text(filterText())
                .font(.title)
                .padding(.bottom)

            if activeFilter == .all {
                Image(systemName: "arrow.down")
                    .font(.largeTitle)
            }
            Spacer()
        }
    }

    private func filterText() -> String {
        switch activeFilter {
        case .all:
            return "Add a note"
        case .favorite:
            return "No favorite notes"
        @unknown default:
            fatalError()
        }
    }
}

#Preview {
    EmptyListView()
}
