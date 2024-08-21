//
//  EmptyListView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import SwiftUI

struct EmptyListView: View {
    @State private var bounce = false // State variable to trigger animation

    var body: some View {
        VStack {
            Text("Add a note")
                .font(.title)
                .padding(.bottom)

            Image(systemName: "arrow.down")
                .font(.largeTitle)
                .padding(.top, bounce ? 32 : 12)
                .scaleEffect(bounce ? 1.5 : 1.0) // Scale the arrow for bounce effect
                .animation(
                    Animation.easeInOut(duration: 0.5) // Bounce animation duration
                        .repeatForever(autoreverses: true) // Repeat animation with auto-reverse
                )
                .onAppear {
                    bounce.toggle() // Trigger animation when view appears
                }
        }
    }
}

#Preview {
    EmptyListView()
}
