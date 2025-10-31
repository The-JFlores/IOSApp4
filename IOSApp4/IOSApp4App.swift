//
//  IOSApp4App.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-30.
//
import SwiftUI
import FirebaseCore

@main
struct IOSApp4App: App {
    // Initialize Firebase when the app launches
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            EntryListView() // Uses the real view in Views/EntryListView.swift
        }
    }
}
