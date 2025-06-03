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
    @AppStorage("fontSize") var fontSize: Int = 14
    @AppStorage("selectedFont") var selectedFont: AvailableFonts = .system

    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Launch at Login", comment: ""))
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

            Divider()


            HStack {
                Text(NSLocalizedString("Font size", comment: ""))
                    .bold()
                Spacer()
                Stepper("", value: $fontSize, in: 10...24)
            }

            Divider()

            HStack {
                Text(NSLocalizedString("Font", comment: ""))
                    .bold()
                Spacer()
                Picker("", selection: $selectedFont) {
                    ForEach(AvailableFonts.allCases) { font in
                        Text(font.rawValue).tag(font)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding()
        .frame(width: 200)
    }
}

enum AvailableFonts: String, CaseIterable, Identifiable {

    var id: String {
        self.rawValue
    }

    case system = "San Francisco"
    case sfMono = "SF Mono"
    case newYork = "New York"

    func activeFont(with size: Int) -> Font {
        switch self {
        case .system:
            return .system(size: CGFloat(size), weight: .regular, design: .rounded)
        case .newYork:
            return .system(size: CGFloat(size), weight: .regular, design: .serif)
        case .sfMono:
            return .system(size: CGFloat(size), weight: .regular, design: .monospaced)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
