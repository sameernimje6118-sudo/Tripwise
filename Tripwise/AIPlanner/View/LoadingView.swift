//
//  LoadingView.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct LoadingView: View {

    @State private var animate = false
    @State private var messageIndex = 0

    private let messages = [
        "Finding the best flights...",
        "Searching perfect hotels...",
        "Checking weather forecast...",
        "Planning attractions...",
        "Optimizing your budget...",
        "Creating your itinerary..."
    ]

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        ZStack {

            Color.black
                .opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                ZStack {
                    Circle()
                        .stroke(clay.opacity(0.2), lineWidth: 10)
                        .frame(width: 100, height: 100)

                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(clay, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .animation(
                            .linear(duration: 1).repeatForever(autoreverses: false),
                            value: animate
                        )

                    Image(systemName: "sparkles")
                        .font(.system(size: 32))
                        .foregroundStyle(clay)
                }

                VStack(spacing: 10) {
                    Text("TripWise AI")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(ink)

                    Text(messages[messageIndex])
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(stone)
                        .multilineTextAlignment(.center)
                        .id(messageIndex)
                        .transition(.opacity)
                }
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
        .onAppear {
            animate = true
        }
        // Self-cancelling: this task is automatically torn down when LoadingView
        // is removed from the hierarchy (e.g. isLoading flips back to false),
        // so no timer keeps running in the background after the view is gone.
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                guard !Task.isCancelled else { break }
                withAnimation(.easeInOut(duration: 0.25)) {
                    messageIndex = (messageIndex + 1) % messages.count
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
