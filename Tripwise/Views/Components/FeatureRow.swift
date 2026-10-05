//
//  FeatureRow.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct FeatureRow: View {

    let title: String
    let icon: String
    let color: Color

    var body: some View {

        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(title)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)

        }
        .padding()
        .background(.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}
