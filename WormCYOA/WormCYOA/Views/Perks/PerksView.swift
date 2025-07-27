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
    
    var body: some View {
        ScrollView {
            Headline(heading: "Perks", subheading: "Perks are beneficial side effects.")
            
            GridView {
                ForEach(perks, id: \.title) { perk in
                    Group {
                        if perk.count != nil {
                            ItemView(item: character.displayCountedItem(perk, forArr: character.perks), selected: character.isItemSelected(perk, inArr: character.perks), increase: {
                                character.changeCount(of: perk, in: &character.perks, action: .increase)
                                try? modelContext.save()
                            }, decrease: {
                                character.changeCount(of: perk, in: &character.perks, action: .decrease)
                                try? modelContext.save()
                            })
                        } else {
                            Button {
                                character.setValue(for: &character.perks, from: perk)
                                try? modelContext.save()
                            } label: {
                                ItemView(item: perk, selected: character.perks.contains(perk))
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
        .onChange(of: character.perks) { oldValue, newValue in
            if oldValue.contains(where: { $0.title == "Cosmetic Shapeshift" }) && !newValue.contains(where: { $0.title == "Cosmetic Shapeshift" }) {
                if character.overtakenIdentity != nil || character.twin != nil || character.incarnationMethod?.title == "Drop–In" {
                    character.reset([\.sex, \.appearance])
                    character.reset([\.appearanceDesc])
                    try? modelContext.save()
                }
            }
        }
        .onChange(of: character.deletedItems) {
            character.validateRequirements()
            try? modelContext.save()
        }
    }
}
