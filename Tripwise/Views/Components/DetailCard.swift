//
//  DetailCard.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct DetailCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        VStack(spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.orange)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08),
                radius: 12,
                y: 6)
    }
}
