//
//  SettingsCell.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 26.08.24.
//

import SwiftUI

struct SettingsCell: View {

    let imageName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: imageName)
                    .frame(width: 40)
                Text(text)
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
        }
        .buttonStyle(ScalableButtonStyle())
        .padding(.horizontal, 12)
    }
}

struct ScalableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    SettingsCell(imageName: "gear", text: "Einstellungen", action: { })
}
