//
//  EmptyListView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import SwiftUI

struct EmptyListView: View {

    var body: some View {
        VStack {
            Text("Add a note")
                .font(.title)
                .padding(.bottom)

            Image(systemName: "arrow.down")
                .font(.largeTitle)
        }
    }
}

#Preview {
    EmptyListView()
}
