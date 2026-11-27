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
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showingDetails.toggle()
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(.black)
                    )
            }
            .buttonStyle(ScalableButtonStyle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    FloatingButtons(showingDetails: .constant(false))
}
