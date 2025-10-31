//
//  JournalViewModel.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import Foundation
import SwiftUI

/// ViewModel to manage journal entries and interact with FirebaseService
class JournalViewModel: ObservableObject {
    
    @Published var entries: [JournalEntry] = [] // List of entries for UI
    @Published var uploadProgress: Double = 0.0 // Progress of image upload
    
    private let firebaseService = FirebaseService()
    
    // MARK: - Fetch all entries from Firebase
    func fetchEntries() {
        firebaseService.fetchEntries { [weak self] fetchedEntries in
            DispatchQueue.main.async {
                self?.entries = fetchedEntries.sorted { $0.date > $1.date }
            }
        }
    }
    
    // MARK: - Add a new entry
    func addEntry(title: String, description: String, image: UIImage?) {
        let timestamp = Date().timeIntervalSince1970
        var newEntry = JournalEntry(id: nil, title: title, description: description, imageURL: nil, date: timestamp)
        
        // If there is an image, upload it first
        if let image = image {
            let fileName = "entry_\(Int(timestamp))"
            firebaseService.uploadImage(image: image, fileName: fileName, progressHandler: { [weak self] progress in
                DispatchQueue.main.async {
                    self?.uploadProgress = progress
                }
            }, completion: { [weak self] url in
                DispatchQueue.main.async {
                    newEntry.imageURL = url?.absoluteString
                    self?.firebaseService.addEntry(entry: newEntry) { error in
                        if let error = error {
                            print("Error adding entry: \(error.localizedDescription)")
                        } else {
                            self?.fetchEntries()
                        }
                    }
                }
            })
        } else {
            // No image, just add entry
            firebaseService.addEntry(entry: newEntry) { [weak self] error in
                if let error = error {
                    print("Error adding entry: \(error.localizedDescription)")
                } else {
                    self?.fetchEntries()
                }
            }
        }
    }
    
    // MARK: - Update an existing entry
    func updateEntry(entry: JournalEntry) {
        firebaseService.updateEntry(entry: entry) { [weak self] error in
            if let error = error {
                print("Error updating entry: \(error.localizedDescription)")
            } else {
                self?.fetchEntries()
            }
        }
    }
    
    // MARK: - Delete an entry
    func deleteEntry(entry: JournalEntry) {
        firebaseService.deleteEntry(entry: entry) { [weak self] error in
            if let error = error {
                print("Error deleting entry: \(error.localizedDescription)")
            } else {
                self?.fetchEntries()
            }
        }
    }
}
