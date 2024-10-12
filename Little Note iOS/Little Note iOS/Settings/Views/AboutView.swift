//
//  AboutView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 27.08.24.
//

import SwiftUI

struct AboutView: View {

    @State private var tapCount = 0
    @State private var showsEaterEggs = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            detailView()
        }
        .padding()
    }

    private func detailView() -> some View {
        VStack {
            Button {
                tapCount += 1
                if tapCount == 5 {
                    showsEaterEggs.toggle()
                }
            } label: {
                Image("profile_small")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask(Circle())
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray.opacity(0.25), radius: 2,y: 4)
                    .padding(.top)
            }
            .buttonStyle(ScalableButtonStyle())

            Text("""
                 Hi, I'm Kevin 👋

                 I built Little Note because I get distracted way too often.

                 The app helps me to focus on one single task at a time, but still let's me write down important stuff.

                 If you like Little Note, check out the mac version and my social media where I build in public 🤙
                 """)
                .multilineTextAlignment(.leading)
                .padding(.top)

            Divider()

            HStack {
                Text("Watch me build apps")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            .padding(.top, 12)

            SettingsCell(imageName: "camera.fill", text: "YouTube (@kevinchromik)") {
                guard let url = URL(string: "https://www.youtube.com/kevinchromik") else { return }
                UIApplication.shared.open(url)
            }
            .padding(.top)

            SettingsCell(imageName: "person.crop.square.badge.camera.fill", text: "Instagram (@kevinchromik)") {
                guard let url = URL(string: "https://www.instagram.com/kevinchromik") else { return }
                UIApplication.shared.open(url)
            }
            Spacer()
        }
    }
}

#Preview {
    AboutView()
}
