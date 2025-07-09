//
//  CrossroadsView.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftUI

struct CrossroadsView: View {
    @Binding var path: NavigationPath
    @Bindable var character: PlayerCharacter
    
    let tabItems: [Item] = Bundle.main.decode("crossroads.json")
    
    var body: some View {
        ScrollView {
            GridView {
                ForEach(tabItems, id: \.self) { item in
                    Button {
                        path.append(item)
                    } label: {
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
            default:
                Text("Never should happen...")
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
    }
}
