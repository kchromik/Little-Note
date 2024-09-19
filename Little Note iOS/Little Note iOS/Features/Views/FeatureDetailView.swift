//
//  FeatureDetailView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 28.08.24.
//

import SwiftUI

struct FeatureDetailView: View {

    let feature: Feature

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(feature.title)
                    .font(.title)
                    .bold()
                HStack {
                    Text("Upvotes \(feature.upvotes)")
                        .font(.subheadline)
                }
                Text(feature.description)
            }
            .padding(.top)
        }
    }
}

#Preview {
    FeatureDetailView(feature: Feature(id: "", title: "Face ID Unlock", description: "I want to be able to hide notes and make them accessible via Face ID", upvotes: 3, userUpvoted: true))
}
