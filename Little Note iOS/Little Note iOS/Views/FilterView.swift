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
        Text(filter.rawValue)
            .padding([.leading, .trailing], 8)
            .foregroundStyle(isActive ? .yellow : .black)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(isActive ? Color.black : Color.gray.opacity(0.2))
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
