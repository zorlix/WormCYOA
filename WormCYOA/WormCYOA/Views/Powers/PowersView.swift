//
//  PowersView.swift
//  WormCYOA
//
//  Created by Josef Černý on 29.08.2025.
//

import SwiftData
import SwiftUI

struct PowersView: View {
    @Bindable var character: PlayerCharacter
    
    let powers: [Power] = Bundle.main.decode("powers.json")
    let titles: [String: [Item]] = Bundle.main.decode("power_titles.json")
    
    @State private var filterClassifications: [PowerClassification] = PowerClassification.allCases
    @State private var filterTiers: [Int] = [-1, 0, 1, 2, 3]
    @State private var exactMatch: Bool = false
    
    var filteredPowers: [Power] {
        var tempPowers = [Power]()
        let filterSet = Set(filterClassifications)
        
        for power in powers {
            if power.category == .fusion || power.category == .universal {
                tempPowers.append(power)
            }
            
            if power.category == .basePower || power.category == .powerCopy {
                let powerSet = Set(power.classifications)
                
                if exactMatch {
                    if powerSet == filterSet {
                        tempPowers.append(power)
                    }
                } else {
                    if !powerSet.isDisjoint(with: filterSet) {
                        tempPowers.append(power)
                    }
                }
            }
            
            if power.category == .upgrade {
                var viable = false
                if let tier = power.tier {
                    if filterTiers.contains(tier) {
                        viable = true
                    }
                } else {
                    if filterTiers.contains(-1) {
                        viable = true
                    }
                }
                
                if viable {
                    let powerSet = Set(power.classifications)
                    
                    if exactMatch {
                        if powerSet == filterSet {
                            tempPowers.append(power)
                        }
                    } else {
                        if !powerSet.isDisjoint(with: filterSet) {
                            tempPowers.append(power)
                        }
                    }
                }
            }
        }
        
        return tempPowers
    }
    
    var body: some View {
        ScrollView {
            Headline(heading: "Shard Powers", subheading: "Select your Shard abilities")
            
            if character.powerOrigin?.title == "Shardless" {
                PureText("You elected to go without a Shard, so you may not select any parahuman abilities.")
            } else if character.shardType == nil {
                PureText("Please select the origin of your Shard.")
            } else {
                GridView {
                    ForEach(titles["main"]!, id: \.title) { section in
                        if section.title == "Tier 0" {
                            NavigationLink {
                                PowerDisplayView(character: character,
                                                 powerCategory: .basePower,
                                                 heading: section,
                                                 powers: filteredPowers.filter { power in
                                                    if power.category == .basePower || power.tier == 0 {
                                                        return true
                                                    } else {
                                                        return false
                                                    }
                                                 },
                                                 filterClassifications: $filterClassifications,
                                                 filterTiers: $filterTiers,
                                                 exactMatch: $exactMatch)
                            } label: {
                                ItemView(item: section)
                            }
                            .buttonStyle(.plain)
                            .disabled(character.isReqMet(of: section))
                        }
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
    }
}
