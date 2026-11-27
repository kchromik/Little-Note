//
//  EmptyListView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 21.08.24.
//

import LittleBase
import SwiftUI

struct EmptyListView: View {

    @State var activeFilter: Filter = .all

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: iconName())
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 8) {
                    Text(filterText())
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    Text(filterSubtext())
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            if activeFilter != .trash {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 24, weight: .light))
                        .foregroundStyle(.secondary)
                        .opacity(0.6)
                    
                    Text("Tap the + button to get started")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func iconName() -> String {
        switch activeFilter {
        case .all:
            return "note.text"
        case .favorite:
            return "heart"
        case .trash:
            return "trash"
        }
    }

    private func filterSubtext() -> String {
        switch activeFilter {
        case .all:
            return "Create your first note to get started"
        case .favorite:
            return "Mark notes as favorites to see them here"
        case .trash:
            return "Deleted notes appear here for 30 days"
        }
    }

    private func filterText() -> String {
        switch activeFilter {
        case .all:
            return "Add a note"
        case .favorite:
            return "No favorite notes"
        case .trash:
            return "Trash is empty"
        }
    }
}

#Preview {
    EmptyListView()
}
