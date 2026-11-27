//
//  FilterView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import LittleBase
import SwiftUI

struct FilterView: View {

    @Environment(\.colorScheme) var colorScheme

    var filter: Filter
    var isActive: Bool

    var body: some View {
        Text(filter.rawValue)
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(isActive ? .white : .secondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(isActive ? .black : (colorScheme == .dark ? Color(.systemGray5).opacity(0.6) : Color(.systemGray6).opacity(0.8)))
                    .shadow(
                        color: isActive ? .black.opacity(0.2) : .clear,
                        radius: isActive ? 8 : 0,
                        x: 0,
                        y: isActive ? 2 : 0
                    )
            )
            .scaleEffect(isActive ? 1.0 : 0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
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
