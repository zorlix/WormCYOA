//
//  PerksView.swift
//  WormCYOA
//
//  Created by Josef Černý on 15.07.2025.
//

import SwiftData
import SwiftUI

struct PerksView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let perks: [Item] = Bundle.main.decode("perks.json")
    
    @State private var searchString = ""
    
    var filteredPerks: [Item] {
        if searchString.isEmpty {
            return perks
        } else {
            return perks.filter { perk in
                perk.title.localizedStandardContains(searchString)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            Headline(heading: "Perks", subheading: "Perks are beneficial side effects.")
            
            GridView {
                ForEach(filteredPerks, id: \.title) { perk in
                    Group {
                        if perk.count != nil {
                            ItemView(
                                item: character.displayCountedItem(perk, forArr: character.perks),
                                selected: character.isItemSelected(perk, inArr: character.perks),
                                subItems: character.processSubItems(perk.subItems),
                                increase: {
                                    character.changeCount(of: perk, in: &character.perks, action: .increase)
                                    try? modelContext.save()
                                },
                                decrease: {
                                    character.changeCount(of: perk, in: &character.perks, action: .decrease)
                                    try? modelContext.save()
                                })
                        } else {
                            Button {
                                character.setValue(for: &character.perks, from: perk)
                                try? modelContext.save()
                            } label: {
                                ItemView(
                                    item: perk,
                                    selected: character.perks.contains(perk),
                                    subItems: character.processSubItems(perk.subItems)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .disabled(character.isReqMet(of: perk))
                    .disabled(character.isCompatible(perk))
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
        .searchable(text: $searchString)
        .onChange(of: character.deletedItems) {
            character.validateRequirements()
            try? modelContext.save()
        }
    }
}
