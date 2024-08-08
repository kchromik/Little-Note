//
//  Note.swift
//  Little Note
//
//  Created by Kevin Chromik on 03.02.24.
//

import Foundation
import SwiftData

@Model
public class Note {

    public var text: String = ""
    public private(set) var createdAt: Date = Date()
    public var lastUpdated: Date = Date()

    public init() { }

    public var title: String {
        text.components(separatedBy: CharacterSet(charactersIn: " \n")).first ?? ""
    }

    @Attribute(.unique)
    public var formattedCreatedAtDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "de_DE")

        return dateFormatter.string(from: createdAt)
    }

    public var formattedLastUpdatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "de_DE")

        return dateFormatter.string(from: lastUpdated)
    }

    public var numberOfWords: Int {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.count
    }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

extension Note: Identifiable {

    public var id: String {
        createdAt.description
    }
}
