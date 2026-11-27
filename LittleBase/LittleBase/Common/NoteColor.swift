
//
//  NoteColor.swift
//  Little Note
//
//  Created by Kevin Chromik on 08.08.24.
//

import SwiftUI

public enum NoteColor: String, CaseIterable {
    case yellow
    case blue
    case green
    case red
    case purple

    public var color: Color {
        switch self {
        case .yellow:
            return Color(red: 1.0, green: 0.9, blue: 0.4)
        case .blue:
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        case .green:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .red:
            return Color(red: 1.0, green: 0.5, blue: 0.5)
        case .purple:
            return Color(red: 0.8, green: 0.6, blue: 1.0)
        }
    }
}
