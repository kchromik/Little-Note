//
//  FilterView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import SwiftUI

enum Filter: String, CaseIterable {
    case all = "All"
    case favorite = "Favorites"
}

struct FilterView: View {

    var filter: Filter
    @Binding var isActive: Bool
    @State var numberOfItems: Int

    var body: some View {

        HStack(spacing: 0) {
            Text(filter.rawValue)
                .padding([.leading, .trailing], 8)
                .foregroundStyle(.black)

            if isActive {
                Text("\(numberOfItems)")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Circle())
                    .padding(.trailing, 8)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(Color.black, lineWidth: 2) // Add stroke here
        )
        .opacity(isActive ? 1.0 : 0.7)
    }
}

#Preview {
    FilterView(filter: .all, isActive: .constant(true), numberOfItems: 24)
}
