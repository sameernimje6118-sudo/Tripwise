//
//  AddNoteView.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {

    let trip: Trip

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var content = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case title
        case content
    }
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !content.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                scrollContent
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar { toolbarItems }
            .safeAreaInset(edge: .bottom) { saveButton }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = .title
            }
        }
    }

    // MARK: - Scroll Content

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 22) {
                titleField
                contentField
                Spacer(minLength: 120)
            }
            .padding(20)
        }
    }

    // MARK: - Title Field

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("TITLE")

            HStack {
                Image(systemName: "text.cursor")
                    .foregroundStyle(.secondary)
                TextField("e.g. Things to pack", text: $title)
                    .focused($focusedField, equals: .title)
            }
            .padding(15)
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
            }
        }
    }

    // MARK: - Content Field

    private var contentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("CONTENT")

            TextEditor(text: $content)
                .focused($focusedField, equals: .content)
                .frame(minHeight: 200)
                .padding(12)
                .background(.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                }
                .overlay(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Write your note here...")
                            .foregroundStyle(.secondary.opacity(0.6))
                            .padding(16)
                            .allowsHitTesting(false)
                    }
                }
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button {
            let note = Note(
                tripID: trip.id,
                title: title,
                content: content
            )
            focusedField = nil
            modelContext.insert(note)
            dismiss()
        } label: {
            Label("Save Note", systemImage: "checkmark.circle.fill")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color(red: 1.0, green: 0.42, blue: 0.21) : Color.gray.opacity(0.35))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
                .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .padding(.leading, 4)
    }
}

// MARK: - Preview

#Preview {
    AddNoteView(
        trip: Trip(
            title: "Goa",
            destination: "Goa",
            startDate: .now,
            endDate: .now,
            budget: 50000
        )
    )
}
