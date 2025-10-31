//
//  EntryEditView.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import SwiftUI

struct EntryEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: { showImagePicker = true }) {
                        Text("Select Image")
                    }
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                    }
                    if viewModel.uploadProgress > 0 && viewModel.uploadProgress < 1 {
                        ProgressView(value: viewModel.uploadProgress)
                    }
                }
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEntry() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func saveEntry() {
        viewModel.addEntry(title: title, description: description, image: selectedImage)
        dismiss()
    }
}

#Preview {
    EntryEditView()
}
