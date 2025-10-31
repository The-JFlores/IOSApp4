//
//  EntryDetailView.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import SwiftUI

struct EntryDetailView: View {
    let entry: JournalEntry
    @ObservedObject var viewModel: JournalViewModel
    @State private var showEdit = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Imagen (si existe)
                if let urlString = entry.imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .scaledToFit()
                             .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(entry.title)
                    .font(.title)
                    .bold()
                
                Text(entry.description)
                    .font(.body)
                
                Text("Date: \(Date(timeIntervalSince1970: entry.date), style: .date)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Entry Detail")
        .toolbar {
            Button("Edit") {
                showEdit = true
            }
        }
        .sheet(isPresented: $showEdit) {
            EntryEditView(viewModel: viewModel, entryToEdit: entry)
        }
    }
}

#Preview {
    EntryDetailView(entry: JournalEntry(id: "1", title: "Test Entry", description: "This is a test description", imageURL: nil, date: Date().timeIntervalSince1970), viewModel: JournalViewModel())
}
