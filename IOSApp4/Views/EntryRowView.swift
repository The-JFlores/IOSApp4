//
//  EntryRowView.swift
//  IOSApp4
//
//  Created by Jose Flores on 2025-10-31.
//

import SwiftUI

struct EntryRowView: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack {
            if let urlString = entry.imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.headline)
                Text(entry.description)
                    .font(.subheadline)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
#Preview {
    EntryRowView()
}
