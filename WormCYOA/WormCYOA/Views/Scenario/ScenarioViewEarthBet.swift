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
                if character.timeShift?.title == shift.title {
                    ItemView(item: shift, selected: true, count: character.timeShift?.count, increase: { changeCount(with: shift, action: .increase) }, decrease: { changeCount(with: shift, action: .decrease) })
                } else {
                    ItemView(item: shift, selected: false,  increase: { changeCount(with: shift, action: .increase) }, decrease: { changeCount(with: shift, action: .decrease) })
                }
            }
        }
    }
    
    func changeCount(with item: Item, action: CountOperations) {
        if character.timeShift?.title == item.title {
            character.timeShift = character.resolveCount(of: character.timeShift!, action: action)
        } else {
            if action == .increase {
                var tempItem = item
                tempItem.count = 1
                character.timeShift = tempItem
            }
        }
        
        try? modelContext.save()
    }
}
