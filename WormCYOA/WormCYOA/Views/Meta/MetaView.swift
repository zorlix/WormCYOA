//
//  MetaView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftData
import SwiftUI

struct MetaView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let meta: [String: [Item]] = Bundle.main.decode("meta.json")
    
    var body: some View {
        ScrollView {
            Headline(heading: "Meta (Target)", subheading: "Who will your choices affect?")
            GridView {
                ForEach(meta["target"]!, id: \.title) { item in
                    Button {
                        character.setValue(for: &character.metaTarget, from: item)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: item, selected: character.metaTarget == item)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Headline(heading: "Meta (Awareness)", subheading: "Will these choices be made by the target? If so, in what form will they make their choices?")
            GridView {
                ForEach(meta["awareness"]!, id: \.title) { item in
                    Button {
                        character.setValue(for: &character.metaAwareness, from: item)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: item, selected: character.metaAwareness == item)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Headline(heading: "Meta (Other)")
            GridView {
                ForEach(meta["other"]!, id: \.title) { item in
                    Button {
                        character.setValue(for: &character.metaOther, from: item)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: item, selected: character.metaOther == item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
        .onChange(of: character) { oldValue, newValue in
            print("onChange: \(oldValue), \(newValue)")
        }
    }
}
