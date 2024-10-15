//
//  EasterEggView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 12.10.24.
//

import SwiftUI

struct EasterEggView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Oh, what happened here?")
                .font(.title)
            Text("you found something special\nDo you want to unlock the secret app icon?")
                .multilineTextAlignment(.center)
                .padding()

            Button {
                Task {
                    await CommonUtils.updateAppIcon(with: "AppIconEasterEgg")
                }
            } label: {
                Image("top-secret")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
            }
            .buttonStyle(ScalableButtonStyle())

            Spacer()
        }
    }
}

#Preview {
    EasterEggView()
}

actor CommonUtils {

    static func updateAppIcon(with iconName: String?) async {
        Task {
            do {
                guard await UIApplication.shared.alternateIconName != iconName else {
                    return
                }
                try await UIApplication.shared.setAlternateIconName(iconName)
            } catch {
                print("Could not update icon \(error.localizedDescription)")
            }
        }
    }
}
