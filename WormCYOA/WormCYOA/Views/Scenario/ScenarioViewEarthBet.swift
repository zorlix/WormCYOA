//
//  ScenarioViewEarthBet.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftData
import SwiftUI

struct ScenarioViewEarthBet: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let scenarios: [String: [Item]]

    var body: some View {
        GridView {
            ForEach(scenarios["earthBet"]!, id: \.title) { scenario in
                Button {
                    character.setValue(for: &character.scenario, from: scenario)
                    try? modelContext.save()
                } label: {
                    ItemView(item: scenario, selected: character.scenario == scenario, difficulty: character.difficulty)
                }
                .buttonStyle(.plain)
            }
        }
        
        Headline(heading: "Time Shift", subheading: "Is the exact moment of arrival as outlined by the Scenarios not to your liking?\nNever fear!\nWith the options below you can adjust the moment of your arrival as much as you desire.")
        GridView {
            ForEach(scenarios["timeShift"]!, id: \.title) { shift in
                ItemView(item: character.displayCountedItem(shift, forVar: character.timeShift), selected: character.isItemSelected(shift, inVar: character.timeShift), increase: {
                    character.changeCount(of: shift, for: &character.timeShift, action: .increase)
                    try? modelContext.save()
                }, decrease: {
                    character.changeCount(of: shift, for: &character.timeShift, action: .decrease)
                    try? modelContext.save()
                })
            }
        }
    }
}
