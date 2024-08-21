//
//  FloatingButtons.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 19.08.24.
//
import SwiftUI

struct FloatingButtons: View {

    @Binding var showingDetails: Bool

    var body: some View {
        HStack(spacing: 12) {
            Button {
                showingDetails.toggle()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 44, height: 44)
                    .background(Color.black)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(.thinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 8)
    }
}

#Preview {
    FloatingButtons(showingDetails: .constant(false))
}
