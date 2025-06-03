//
//  TextPad.swift
//  Little Note
//
//  Created by Kevin Chromik on 09.02.24.
//

import LittleBase
import SwiftUI

struct TextPad: View {

    @Bindable var note: Note
    @AppStorage("fontSize") var fontSize: Int = 14
    @AppStorage("selectedFont") var selectedFont: AvailableFonts = .system

    var body: some View {
        TextEditor(text: bindingForTextEditor())
            .font(selectedFont.activeFont(with: fontSize))
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
    }

    private func bindingForTextEditor() -> Binding<String> {
        Binding<String>(
            get: {
                self.note.text
            },
            set: {
                note.lastUpdated = Date()
                note.text = $0
            }
        )
    }
}
