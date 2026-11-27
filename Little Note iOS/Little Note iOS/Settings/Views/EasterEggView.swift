//
//  EasterEggView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 12.10.24.
//

import SwiftUI

struct EasterEggView: View {

    @State private var isUnlocked: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Text("Oh, what happened here?")
                .font(.title)
            Text("You found something special\nDo you want to unlock the secret app icon?")
                .multilineTextAlignment(.center)
                .padding()

            Button {
                Task {
                    if isUnlocked {
                        await CommonUtils.updateAppIcon(with: nil)
                    } else {
                        await CommonUtils.updateAppIcon(with: "AppIconEasterEgg")
                    }
                    withAnimation {
                        isUnlocked.toggle()
                    }
                }
            } label: {
                if isUnlocked {
                    Text("Reset to default")
                        .font(.headline)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                } else {
                    Image("top-secret")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                }
            }
            .buttonStyle(ScalableButtonStyle())

            Spacer()
        }
        .onAppear {
            isUnlocked = UIApplication.shared.alternateIconName == "AppIconEasterEgg"
        }
    }
}

#Preview {
    EasterEggView()
}

actor CommonUtils {

    static func updateAppIcon(with iconName: String?) async {
        Task {
            // Check if we are already using the desired icon
            guard await UIApplication.shared.alternateIconName != iconName else {
                return
            }

            // Ensure the following is executed on the main thread
            await MainActor.run {
                UIApplication.shared.setAlternateIconName(iconName)
            }
        }
    }
}
