//
//  Note.swift
//  Little Note
//
//  Created by Kevin Chromik on 03.02.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public class Note {

    public var customTitle: String = ""
    public var text: String = ""
    public private(set) var createdAt: Date = Date()
    public var lastUpdated: Date = Date()
    public var isFavourite: Bool = false

    private var uuidString: String = ""

    public init(title: String = "", text: String = "") {
        self.customTitle = title
        self.text = text
        self.uuidString = UUID().uuidString
    }

    public var title: String {
        guard !customTitle.isEmpty else {
            return text.components(separatedBy: CharacterSet(charactersIn: " \n")).first ?? ""
        }
        return customTitle
    }

    public var formattedCreatedAtDate: String {
        let dateFormatter = DateFormatter()

        var dateText = ""
        if Calendar.current.isDateInToday(createdAt) {
            dateText = "Today "
            dateFormatter.dateFormat = "HH:mm"
        } else if Calendar.current.isDateInYesterday(createdAt) {
            dateText = "Yesterday "
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        }
        dateFormatter.locale = Locale(identifier: "de_DE")

        return dateText + dateFormatter.string(from: createdAt)
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

    public var formattedNumberOfWords: LocalizedStringKey {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        let count = components.filter { !$0.isEmpty }.count

        return "^[\(count) Word](inflect: true)"
    }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

extension Note: Identifiable {

    @Attribute(.unique)
    public var id: String {
        uuidString
    }
}
