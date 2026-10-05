//
//  AppBackground.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//


import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Circle()
                .fill(Color(red: 1.0, green: 0.91, blue: 0.84))
                .frame(width: 360, height: 360)
                .offset(x: 130, y: -220)
                .blur(radius: 50)

            Circle()
                .fill(Color(red: 0.84, green: 0.94, blue: 1.0))
                .frame(width: 320, height: 320)
                .offset(x: -130, y: 240)
                .blur(radius: 50)
        }
    }
}