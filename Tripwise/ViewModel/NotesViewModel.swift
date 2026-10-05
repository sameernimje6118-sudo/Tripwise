//
//  NotesViewModel.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import Observation

@Observable
class NotesViewModel {

    var notes: [Note] = []

    func addNote(_ note: Note) {
        notes.append(note)
    }

    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }

}
