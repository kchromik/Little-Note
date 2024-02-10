//
//  Note.swift
//  Little Note
//
//  Created by Kevin Chromik on 03.02.24.
//

import Foundation

import Foundation
import SwiftData

@Model
class Note {

    var text: String = "" {
        didSet {
            lastUpdated = Date()
        }
    }
    var createdAt: Date
    var lastUpdated: Date

    init() {
        let date = Date()
        createdAt = date
        lastUpdated = date
    }

    var title: String {
        let separators = CharacterSet(charactersIn: " \n")
        return text.components(separatedBy: separators).first ?? ""
    }

    var formattedLastUpdatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        dateFormatter.locale = Locale(identifier: "de_DE")

        return dateFormatter.string(from: lastUpdated)
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

extension Note: Identifiable {
    var id: String {
        createdAt.description
    }
}
