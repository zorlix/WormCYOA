//
//  FamilyView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct FamilyView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let familySituations: [Item]
    
    var body: some View {
        Headline(heading: "Family Situation", subheading: "How large is your family going to be? Are both of your parents going to be around? Or are you going to be an oprhan??")
        
        GridView {
            ForEach(familySituations, id: \.title) { family in
                Button {
                    character.setValue(for: &character.family, from: family)
                    try? modelContext.save()
                } label: {
                    ItemView(item: family, selected: character.family == family)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
