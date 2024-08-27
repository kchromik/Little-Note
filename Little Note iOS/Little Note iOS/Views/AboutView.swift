//
//  AboutView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 27.08.24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Image("profile_small")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(Circle())
                .frame(width: 100, height: 100)

            Text("Hi, I'm Kevin")
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    AboutView()
}
