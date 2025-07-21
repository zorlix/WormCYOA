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
                    ItemView(item: perk)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
    }
}
