//
//  SettingsView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 26.08.24.
//

import SwiftUI

struct SettingsView: View {

    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            VStack {

                List {
                    SettingsCell(imageName: "envelope", text: "Support")
                        .listRowSeparator(.hidden)
                    SettingsCell(imageName: "bubble.left.and.text.bubble.right", text: "Support")
                }
                .listStyle(.insetGrouped)

                Spacer()
                Text("Little Note \(viewModel.versionString)")
                    .bold()
                    .padding()
                    .background(.clear)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
