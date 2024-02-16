//
//  TextPad.swift
//  Little Note
//
//  Created by Kevin Chromik on 09.02.24.
//

import SwiftUI

struct TextPad: View {

    @Bindable var note: Note

    var body: some View {
        TextEditor(text: bindingForTextEditor())
            .font(.body)
            .background(Color.white)
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
                checkForBulletPointInsertion(currentText: self.note.text)
            }
        )
    }

    private func checkForBulletPointInsertion(currentText: String) {
        let lines = currentText.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)

        // Detect if the user is trying to exit a bullet list by pressing Enter on an empty bullet point line
        if currentText.hasSuffix("\n") && lines.count >= 2 && lines[lines.count - 2].trimmingCharacters(in: .whitespaces) == "\u{2022}" {
            // Remove the last two characters (bullet point and newline) and add a new newline to exit the bullet list
            self.note.text.removeLast(3) // Remove the bullet point "\u{2022} " and the newline
            self.note.text += "\n" // Add back a single newline to create an empty new line
        } else if currentText.hasSuffix("\n") && lines.count >= 2 && lines[lines.count - 2].starts(with: "\u{2022} ") {
            // If the user presses Enter at the end of a bullet point line, start a new bullet point line
            self.note.text += "\u{2022} "
        } else if let lastLine = lines.last, lastLine == "-" {
            // Replace "-" with a bullet point if it's alone on the last line
            self.note.text.removeLast()
            self.note.text += "\u{2022} "
        }
    }
}
