//
//  FeaturesList.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 28.08.24.
//

import SwiftUI

struct FeaturesList: View {

    @StateObject var viewModel = FeatureViewModel()
    @State var isShowingFeatureDetails: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.features) { feature in

                    FeatureView(feature: feature) {
                        withAnimation {
                            viewModel.toggleUpvote(feature: feature)
                        }
                    } selectAction: {
                        isShowingFeatureDetails.toggle()
                    }
                    .sheet(isPresented: $isShowingFeatureDetails) {
                        FeatureDetailView(feature: feature)
                            .presentationDetents([.fraction(0.3)])
                    }
                }
            }
            .navigationTitle("Feature Requests")
        }
    }
}

#Preview {
    FeaturesList()
}
