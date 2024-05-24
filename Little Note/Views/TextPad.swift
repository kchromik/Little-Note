//
//  TextPad.swift
//  Little Note
//
//  Created by Kevin Chromik on 09.02.24.
//

import SwiftUI

struct TextPad: View {

    @Bindable var note: Note
    @AppStorage("usesLargeFont") var usesLargeFont: Bool = false

    var body: some View {
        TextEditor(text: bindingForTextEditor())
            .font(.system(size: usesLargeFont ? 18 : 14, weight: .regular, design: .rounded))
//            .font(usesLargeFont ? .headline : .body)
    }

    private func bindingForTextEditor() -> Binding<String> {
        Binding<String>(
            get: {
                self.note.text
            },
            set: {
                withAnimation {
                    note.lastUpdated = Date()
                }
                note.text = $0
            }
        )
    }
}
