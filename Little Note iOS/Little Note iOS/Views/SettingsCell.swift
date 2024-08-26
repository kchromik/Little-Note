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

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
            Spacer()
        }
    }
}

#Preview {
    SettingsCell(imageName: "gear", text: "Einstellungen")
}
