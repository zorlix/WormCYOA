//
//  DrawbacksView.swift
//  WormCYOA
//
//  Created by Josef Černý on 25.07.2025.
//

import SwiftData
import SwiftUI

struct DrawbacksView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let drawbacks: [Item] = Bundle.main.decode("drawbacks.json")
    
    @State private var searchString = ""
    
    var filteredDrawbacks: [Item] {
        if searchString.isEmpty {
            return drawbacks
        } else {
            return drawbacks.filter { item in
                item.title.localizedStandardContains(searchString)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            Headline(heading: "Drawbacks", subheading: "Drawbacks are side-effects that harm or hinder you.")
            
            GridView {
                ForEach(filteredDrawbacks, id: \.title) { drawback in
                    Group {
                        if drawback.count != nil {
                            ItemView(
                                item: character.displayCountedItem(drawback, forArr: character.drawbacks),
                                selected: character.isItemSelected(drawback, inArr: character.drawbacks),
                                subItems: character.processSubItems(drawback.subItems),
                                difficulty: character.difficulty,
                                increase: {
                                    character.changeCount(of: drawback, in: &character.drawbacks, action: .increase)
                                    try? modelContext.save()
                                },
                                decrease: {
                                    character.changeCount(of: drawback, in: &character.drawbacks, action: .decrease)
                                    try? modelContext.save()
                                }
                            )
                        } else {
                            Button {
                                character.setValue(for: &character.drawbacks, from: drawback)
                                try? modelContext.save()
                            } label: {
                                ItemView(
                                    item: drawback,
                                    selected: character.drawbacks.contains(drawback),
                                    subItems: character.processSubItems(drawback.subItems),
                                    difficulty: character.difficulty
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .disabled(character.isReqMet(of: drawback))
                    .disabled(character.isCompatible(drawback))
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
        .onChange(of: character.drawbacks) { oldValue, newValue in
            let title = "Deviant"
            
            if oldValue.contains(where: { $0.title == title }) && !newValue.contains(where: {$0.title == title }) {
                character.deviantForm = nil
                character.deviantRolledRandomly = false
                try? modelContext.save() 
            }
        }
    }
}
