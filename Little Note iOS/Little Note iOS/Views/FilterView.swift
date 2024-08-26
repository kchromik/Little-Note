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
                .foregroundStyle(isActive ? . white : .black)
                .padding(4)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(isActive ? Color.black : Color.gray.opacity(0.3))
        )
    }
}

#Preview {

    do {
        let previewer = try Previewer()

        return FilterView(filter: .all, isActive: false)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
