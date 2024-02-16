//
//  SettingsView.swift
//  Little Note
//
//  Created by Kevin Chromik on 16.02.24.
//

import SwiftUI

struct SettingsView: View {

    private struct Constants {
        static let helperBundleID = "com.kchromik.AutoLauncher"
    }

    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("launchAtLogin", comment: ""))
                    .bold()
                Spacer()
                Button {
                    withAnimation {
                        viewModel.launchAtLogin.toggle()
                    }
                } label: {
                    Image(systemName: viewModel.launchAtLogin ? "checkmark.square.fill" : "square")
                }
                .buttonStyle(.plain)
            }

            Divider()

            HStack(spacing: 0) {
                Text("Hotkey")
                    .bold()
                    .padding(.trailing)
                Image(systemName: "control")
                Image(systemName: "option")
                Image(systemName: "command")
                Text("+ L")
                Spacer()
                Button {
                    withAnimation {
                        viewModel.hotkeyEnabled.toggle()
                    }
                } label: {
                    Image(systemName: viewModel.hotkeyEnabled ? "checkmark.square.fill" : "square")
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(width: 240)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
