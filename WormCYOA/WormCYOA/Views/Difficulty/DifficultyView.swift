//
//  DifficultyView.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftData
import SwiftUI

struct DifficultyView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let difficulties: [Item] = Bundle.main.decode("difficulty.json")
    
    var body: some View {
        ScrollView {
            Headline(heading: "Difficulty")
            GridView {
                ForEach(difficulties, id: \.title) { diff in
                    Button {
                        character.setValue(for: &character.difficulty, from: diff)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: diff, selected: character.difficulty == diff)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
    }
}
