//
//  SexView.swift
//  WormCYOA
//
//  Created by Josef Černý on 13.07.2025.
//

import SwiftData
import SwiftUI

struct SexView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let sexes: [Item]
    
    var body: some View {
        Headline(heading: "Sex", subheading: "Your sex — Is your body male, female, or other?\nBe warned that you might start suffering from dismorphia if you choose a sex different from your gender.")
        GridView {
            ForEach(sexes, id: \.title) { sex in
                Button {
                    character.setValue(for: &character.sex, from: sex)
                    try? modelContext.save()
                } label: {
                    ItemView(item: sex, selected: character.sex == sex)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
