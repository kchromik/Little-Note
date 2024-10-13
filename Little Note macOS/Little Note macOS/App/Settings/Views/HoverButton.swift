//
//  HoverButton.swift
//  Little Note
//
//  Created by Kevin Chromik on 24.05.24.
//

import SwiftUI

struct HoverButton: View {
    var imageName: String
    var action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: isHovered ? "\(imageName).fill" : imageName)
        }
        .buttonStyle(.bordered)
        .tint(.pink)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
