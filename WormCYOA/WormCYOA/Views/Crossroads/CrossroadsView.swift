//
//  CrossroadsView.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftData
import SwiftUI

struct CrossroadsView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let tabItems: [Item] = Bundle.main.decode("crossroads.json")
    
    var body: some View {
        ScrollView {
            GridView {
                ForEach(tabItems, id: \.self) { item in
                    NavigationLink(value: item) {
                        ItemView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("New Character")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Item.self) { item in
            switch item.title {
            case "Lore":
                LoreView()
            case "Meta":
                MetaView(character: character)
            case "Difficulty":
                DifficultyView(character: character)
            case "Setting":
                SettingView(character: character)
            case "Scenario":
                ScenarioView(character: character)
            case "Character":
                CharacterView(character: character)
            case "Perks":
                PerksView(character: character)
            case "Drawbacks":
                DrawbacksView(character: character)
            default:
                Text("Never should happen...")
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
        .onAppear {
            character.validateRequirements()
            try? modelContext.save()
        }
    }
}
