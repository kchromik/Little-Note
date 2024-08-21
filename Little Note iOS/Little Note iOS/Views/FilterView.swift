//
//  FilterView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import LittleBase
import SwiftUI

enum Filter: String, CaseIterable {
    case all = "All"
    case favorite = "Favorites"
}

struct FilterView: View {

    var filter: Filter
    var isActive: Bool

    var body: some View {

        HStack(spacing: 0) {
            Text(filter.rawValue)
                .padding([.leading, .trailing], 8)
                .foregroundStyle(.black)
                .padding(isActive ? 4 : 0)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

#Preview {

    do {
        let previewer = try Previewer()

        return FilterView(filter: .all, isActive: true)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
