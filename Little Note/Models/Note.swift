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

    var text: String = ""
    var createdAt: Date
    var lastUpdated: Date

    init() {
        let date = Date()
        createdAt = date
        lastUpdated = date
    }

    var title: String {
        text.components(separatedBy: CharacterSet(charactersIn: " \n")).first ?? ""
    }

    var formattedLastUpdatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
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
