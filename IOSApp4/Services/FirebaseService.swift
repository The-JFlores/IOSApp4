//
//  FirebaseService.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import SwiftUI

/// Service class to handle Firebase operations: CRUD for Realtime Database and file upload
class FirebaseService: ObservableObject {

    // MARK: - Database reference
    private let databaseRef = Database.database().reference()
    
    // MARK: - Storage reference
    private let storageRef = Storage.storage().reference()
    
    // MARK: - Insert / Create a new journal entry
    /// Adds a new journal entry to Firebase Realtime Database
    func addEntry(entry: JournalEntry, completion: @escaping (Error?) -> Void) {
        let entryRef = databaseRef.child("entries").childByAutoId()
        entryRef.setValue(entry.toDictionary()) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Read / Retrieve all journal entries
    /// Fetches all journal entries from Firebase Realtime Database
    func fetchEntries(completion: @escaping ([JournalEntry]) -> Void) {
        databaseRef.child("entries").observeSingleEvent(of: .value) { snapshot in
            var entries: [JournalEntry] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let entry = JournalEntry.fromDictionary(dict: dict, id: snap.key) {
                    entries.append(entry)
                }
            }
            completion(entries)
        }
    }
    
    // MARK: - Update an existing journal entry
    /// Updates a journal entry by its id
    func updateEntry(entry: JournalEntry, completion: @escaping (Error?) -> Void) {
        guard let id = entry.id else {
            completion(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entry ID missing"]))
            return
        }
        databaseRef.child("entries").child(id).updateChildValues(entry.toDictionary()) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Delete a journal entry
    /// Deletes a journal entry by its id
    func deleteEntry(entry: JournalEntry, completion: @escaping (Error?) -> Void) {
        guard let id = entry.id else {
            completion(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Entry ID missing"]))
            return
        }
        databaseRef.child("entries").child(id).removeValue { error, _ in
            completion(error)
        }
    }
    
    // MARK: - Upload image with progress
    /// Uploads a UIImage to Firebase Storage and returns the download URL
    func uploadImage(image: UIImage, fileName: String, progressHandler: @escaping (Double) -> Void, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let imageRef = storageRef.child("images/\(fileName).jpg")
        let uploadTask = imageRef.putData(imageData, metadata: nil)
        
        // Observe progress
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress?.fractionCompleted ?? 0)
            progressHandler(percentComplete)
        }
        
        // Observe completion
        uploadTask.observe(.success) { _ in
            imageRef.downloadURL { url, _ in
                completion(url)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            print("Upload failed: \(snapshot.error?.localizedDescription ?? "unknown error")")
            completion(nil)
        }
    }
}
