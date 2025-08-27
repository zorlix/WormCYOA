//
//  PowerOriginsView.swift
//  WormCYOA
//
//  Created by Josef Černý on 25.08.2025.
//

import SwiftData
import SwiftUI

struct PowerOriginsView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let powerOrigins: [String: [Item]] = Bundle.main.decode("power_origins.json")
    
    var body: some View {
        ScrollView {
            Headline(heading: "Power Origins", subheading: "In the Wonderful World of Worm, parahuman abilities are granted by Shards, fragments of incomprehensibly immense interdimensional Entities. In this section you may pick if yuo'd like this CYOA to connect you to a Shard of your own.")
            
            GridView {
                ForEach(powerOrigins["powerOrigins"]!, id: \.title) { origin in
                    Button {
                        character.setValue(for: &character.powerOrigin, from: origin)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: origin, selected: character.powerOrigin == origin)
                    }
                    .buttonStyle(.plain)
                }
            }
            .onChange(of: character.powerOrigin) {
                character.reset([\.shardType, \.shardRank, \.shardRelationship])
                character.shardDeviancy = []
                try? modelContext.save()
            }
            
            if character.powerOrigin?.title == "Shard" {
                Headline(heading: "Shard Origin", subheading: "Which Entity does your Shard come from?")
                
                GridView {
                    ForEach(powerOrigins["shardType"]!, id: \.title) { type in
                        Button {
                            character.setValue(for: &character.shardType, from: type)
                            try? modelContext.save()
                        } label: {
                            ItemView(item: type, selected: character.shardType == type)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Headline(heading: "Shard Caliber", subheading: "Not all Shards were created equal. Select how vital yours was to its parent Entity.")
                
                GridView {
                    ForEach(powerOrigins["shardRanking"]!, id: \.title) { rank in
                        Button {
                            character.setValue(for: &character.shardRank, from: rank)
                            try? modelContext.save()
                        } label: {
                            ItemView(item: rank, selected: character.shardRank == rank)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Headline(heading: "Shard Relationship", subheading: "This choice determines your Shard's disposition towards you, a crucial factor that will impact both your powers and your personal well-being.")
                
                GridView {
                    ForEach(powerOrigins["shardRelationship"]!, id: \.title) { ship in
                        Button {
                            character.setValue(for: &character.shardRelationship, from: ship)
                            try? modelContext.save()
                        } label: {
                            ItemView(item: ship, selected: character.shardRelationship == ship)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Headline(heading: "Shard Deviancy", subheading: "Is your Shard in certain ways bending the rules of the Cycle? Each choice adds a layer of deviancy.\nWarning: Too much deviation may draw unwanted attention from Scion, who may seek to destroy such a dangerous anomaly. Certain perks or powers that cloak your presence might protect to a certain degree.")
                
                GridView {
                    ForEach(powerOrigins["shardDeviancy"]!, id: \.title) { dev in
                        Button {
                            character.setValue(for: &character.shardDeviancy, from: dev)
                            try? modelContext.save()
                        } label: {
                            ItemView(
                                item: dev,
                                selected: character.shardDeviancy.contains(dev)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
        .onChange(of: character.deletedItems) {
            character.validateRequirements()
            try? modelContext.save()
        }
    }
}
