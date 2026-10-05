//
//  SavedAIPlansView.swift
//  Tripwise
//
//  Created by sameer nimje on 07/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct SavedAIPlansView: View {

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "bookmark.slash")
                .font(.system(size: 50))
                .foregroundStyle(.orange)

            Text("No Saved AI Plans")
                .font(.title2.bold())

            Text("Saving AI itineraries will be available in Version 2.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

        }
        .padding()
        .navigationTitle("Saved Plans")

    }

}

#Preview {

    NavigationStack {

        SavedAIPlansView()

    }

}
