//
//  FeatureView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 28.08.24.
//

import SwiftUI

struct FeatureView: View {

    var feature: Feature
    var upvoteAction: () -> Void
    var selectAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(feature.title)
                    .bold()
                Text(feature.description)
                    .lineLimit(2)
            }
            .onTapGesture {
                selectAction()
            }

            Button {
                upvoteAction()
            } label: {
                HStack {
                    Text("\(feature.upvotes)")
                    Image(systemName: feature.userUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                }
            }
        }
    }
}

#Preview {
    FeatureView(feature: Feature(id: "", title: "Face ID Unlock", description: "I want to be able to hide notes and make them accessible via Face ID", upvotes: 3, userUpvoted: true), upvoteAction: { }, selectAction: { })
}
