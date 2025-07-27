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
    
    var body: some View {
        ScrollView {
            Headline(heading: "Drawbacks", subheading: "Drawbacks are side-effects that harm or hinder you.")
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
