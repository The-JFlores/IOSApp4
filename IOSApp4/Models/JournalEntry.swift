//
//  JournalEntry.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import Foundation
import SwiftUI

/// Model representing a single journal entry
struct JournalEntry: Identifiable {
    var id: String? // Firebase ID
    var title: String
    var description: String
    var imageURL: String? // URL of image in Firebase Storage
    var date: TimeInterval // timestamp
    
    /// Convert JournalEntry to a dictionary for Firebase
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": description,
            "imageURL": imageURL ?? "",
            "date": date
        ]
    }
    
    /// Create JournalEntry from Firebase dictionary
    static func fromDictionary(dict: [String: Any], id: String) -> JournalEntry? {
        guard let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let date = dict["date"] as? TimeInterval else {
            return nil
        }
        let imageURL = dict["imageURL"] as? String
        return JournalEntry(id: id, title: title, description: description, imageURL: imageURL, date: date)
    }
}
