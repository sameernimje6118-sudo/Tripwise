//
//  SummaryItem.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//
import SwiftUI

struct SummaryItem: View {

    let title: String
    let value: Double
    let color: Color

    var body: some View {

        VStack(spacing: 6) {

            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay {

                    Circle()
                        .fill(color)
                        .frame(width: 10)

                }

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("₹\(value, specifier: "%.0f")")
                .font(.headline)

        }

    }

}
