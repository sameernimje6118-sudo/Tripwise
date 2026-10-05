//
//  NotesView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//
import SwiftUI
import SwiftData

struct NotesView: View {

    let trip: Trip
    @State private var showAddNote = false
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]

    var tripNotes: [Note] {
        notes.filter { $0.tripID == trip.id }
    }

    var body: some View {
        ZStack {
            AppBackground()

            if tripNotes.isEmpty {
                emptyState
            } else {
                notesList
            }
        }
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddNote = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showAddNote) {
            AddNoteView(trip: trip)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.95, blue: 0.93))
                    .frame(width: 90, height: 90)

                Image(systemName: "note.text")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
            }

            VStack(spacing: 6) {
                Text("No Notes")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Tap + to create your first note.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Notes List

    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(tripNotes) { note in
                    noteCard(note)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Note Card

    private func noteCard(_ note: Note) -> some View {
        HStack(spacing: 14) {

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.93))
                .frame(width: 42, height: 42)
                .overlay {
                    Image(systemName: "note.text")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(note.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NotesView(
            trip: Trip(
                title: "Goa",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
    }
}
