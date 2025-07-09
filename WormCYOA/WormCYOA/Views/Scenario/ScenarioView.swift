//
//  ScenarioView.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftData
import SwiftUI

struct ScenarioView: View {
    @Bindable var character: PlayerCharacter
    
    let scenarios: [String: [Item]] = Bundle.main.decode("scenarios.json")
    
    var body: some View {
        ScrollView {
            Headline(heading: "Scenario")
            
            if let setting = character.setting {
                switch setting.title {
                case "Canon Earth Bet":
                    ScenarioViewEarthBet(character: character, scenarios: scenarios)
                case "Alternate World":
                    Text("Coming soon...")
                case "Crossover":
                    Text("Coming soon...")
                case "No Transfer":
                    MinorHeadline(text: "No Transfer")
                    PureText("You've chosen to remain in your original universe, so there are no scenarios to be picked. You will remain exactly where you are, when you are. No reason to send you back or forward in time in your own home universe.\nThis also means that you will not receive extra points for picking certain scenarios.")
                default:
                    EmptyView()
                }
            } else {
                PureText("You must choose a setting before selecting a scenario...")
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
    }
}
