//
//  SettingsView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 26.08.24.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @State var viewModel = SettingsViewModel()
    @State var isShowingAbout: Bool = false
    @State var isShowingFeatureRoadmap: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Settings")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .tint(.black)
                            .padding(8)
                    }
                    .buttonStyle(ScalableButtonStyle())
                }
                .padding([.vertical, .horizontal], 8)
                ScrollView {
                    VStack {

                        SettingsCell(imageName: "gift", text: "Vote on features") {
                            isShowingFeatureRoadmap.toggle()
                        }

                        SettingsCell(imageName: "envelope", text: "Contact Support") {
                            viewModel.openMail()
                        }

                        SettingsCell(imageName: "heart.fill", text: "About the app") {
                            isShowingAbout.toggle()
                        }
                    }
                    .padding(.horizontal, 8)
                }

                Spacer()
                Text("Little Note \(viewModel.versionString)")
                    .font(.caption2)
                    .padding()
            }
            .sheet(isPresented: $isShowingAbout) {
                AboutView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $isShowingFeatureRoadmap) {
                FeaturesList()
//                WebView(url: "https://insigh.to/b/little-note")
            }
        }
    }
}

#Preview {
    SettingsView()
}
