//
//  SettingViewEarthBet.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftData
import SwiftUI

struct SettingViewEarthBet: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    let settings: [String: [Item]]
    
    var body: some View {
        Headline(heading: "Earth Bet Locations", subheading: "Where will you be reborn/transported?]\nUnless otherwise stated within your chosen options, you can choose the specifics of your location.\nWarning: Your specifications may not contradict any of your selected choices.")
        MinorHeadline(text: "Locations important to Worm canon")
        GridView {
            ForEach(settings["wormCanon"]!, id: \.title) { location in
                Button {
                    character.setValue(for: &character.location, from: location)
                    try? modelContext.save()
                } label: {
                    ItemView(item: location, selected: character.location == location)
                }
                .buttonStyle(.plain)
            }
        }
        
        MinorHeadline(text: "Random locations across the world.")
        GridView {
            ForEach(settings["wormRandom"]!, id: \.title) { location in
                Button {
                    character.setValue(for: &character.location, from: location)
                    try? modelContext.save()
                } label: {
                    ItemView(item: location, selected: character.location == location)
                }
                .buttonStyle(.plain)
            }
        }
        
        MinorHeadline(text: "Generic locations")
        GridView {
            ForEach(settings["wormGeneric"]!, id: \.title) { location in
                Button {
                    character.setValue(for: &character.location, from: location)
                    try? modelContext.save()
                } label: {
                    ItemView(item: location, selected: character.location == location)
                }
                .buttonStyle(.plain)
            }
        }
        
        MinorHeadline(text: "Alternate Earths")
        GridView {
            ForEach(settings["wormAlernateEarths"]!, id: \.title) { location in
                Button {
                    character.setValue(for: &character.location, from: location)
                    try? modelContext.save()
                } label: {
                    ItemView(item: location, selected: character.location == location)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
