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

    @Environment(\.colorScheme) var colorScheme

    var filter: Filter
    var isActive: Bool

    var body: some View {
        Text(filter.rawValue)
            .padding([.leading, .trailing], 8)
            .foregroundStyle(isActive ? (colorScheme == .dark ? .black : .yellow) : (colorScheme == .dark ? .white : .black))
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(isActive ? (colorScheme == .dark ? .yellow : Color.black) : (colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.2)) )
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
