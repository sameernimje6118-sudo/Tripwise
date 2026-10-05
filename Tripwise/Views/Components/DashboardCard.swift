//
//  DashboardCard.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct DashboardCard: View {

    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.12))
                .frame(width: 38, height: 38)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 17))
                        .foregroundStyle(color)
                }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }
}

#Preview {
    ZStack {
    AppBackground()

        HStack(spacing: 12) {
            DashboardCard(title: "Trips", value: "12", icon: "airplane", color: .orange)
            DashboardCard(title: "Spent", value: "₹48k", icon: "indianrupeesign", color: .green)
        }
        .padding()
    }
}
