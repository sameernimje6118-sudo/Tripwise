//
//  AttractionCardView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AttractionCardView: View {

    let attraction: AttractionSearchResult

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack(alignment: .top, spacing: 14) {

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay {

                        Image(systemName: "camera.metering.center.weighted")
                            .font(.system(size: 24))
                            .foregroundStyle(.green)

                    }

                VStack(alignment: .leading, spacing: 6) {

                    Text(attraction.name)
                        .font(.headline)

                    Label(attraction.address,
                          systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    if let rating = attraction.rating {

                        HStack(spacing: 4) {

                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)

                            Text(String(format: "%.1f", rating))
                                .font(.caption)

                        }

                    }

                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)

            }

        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {

            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.05))

        }
        .shadow(color: .black.opacity(0.05),
                radius: 8,
                y: 4)

    }

}

#Preview {

    AttractionCardView(
        attraction: AttractionSearchResult(
            id: UUID(),
            name: "Baga Beach",
            address: "Goa, India",
            rating: 4.8,
            latitude: 15.56,
            longitude: 73.75
        )
    )

}
