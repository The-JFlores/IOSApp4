//
//  EntryListView.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import SwiftUI

struct EntryListView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var showAddEntry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                        EntryRowView(entry: entry)
                    }
                }
                .onDelete(perform: deleteEntry)
            }
            .navigationTitle("Journal Entries")
            .toolbar {
                Button(action: { showAddEntry = true }) {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                viewModel.fetchEntries()
            }
            .sheet(isPresented: $showAddEntry) {
                EntryEditView(viewModel: viewModel)
            }
        }
    }
    
    // Delete entry
    private func deleteEntry(at offsets: IndexSet) {
        offsets.forEach { index in
            let entry = viewModel.entries[index]
            viewModel.deleteEntry(entry: entry)
        }
    }
}
#Preview {
    EntryListView()
}
