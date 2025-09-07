//
//  PowerDisplayView.swift
//  WormCYOA
//
//  Created by Josef Černý on 07.09.2025.
//

import SwiftData
import SwiftUI

struct PowerDisplayView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let powerCategory: PowerCategory
    let heading: Item
    let powers: [Power]
    
    @Binding var filterClassifications: [PowerClassification]
    @Binding var filterTiers: [Int]
    @Binding var exactMatch: Bool
    @State private var searchString = ""
    
    var filteredPowers: [Power] {
        if searchString.isEmpty {
            return powers
        } else {
            return powers.filter { power in
                power.details.title.localizedStandardContains(searchString)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            Headline(heading: heading.title, subheading: heading.desc)
            
            GridView {
                ForEach(filteredPowers, id: \.details.title) { power in
                    Button {
                        character.setValue(for: &character.powers, from: power)
                        try? modelContext.save()
                    } label: {
                        PowerView(
                            power: power,
                            selected: character.powers.contains(power),
                            subItems: character.processSubItems(power.details.subItems)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
        .searchable(text: $searchString)
        .toolbar {
            PowerFilterView(powerCategory: powerCategory, filterClassifications: $filterClassifications, filterTiers: $filterTiers, exactMatch: $exactMatch)
        }
    }
}
