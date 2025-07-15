//
//  Reincarnation.swift
//  WormCYOA
//
//  Created by Josef Černý on 10.07.2025.
//

import SwiftData
import SwiftUI

struct Reincarnation: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let incarnation: [String: [Item]]
    
    @FocusState.Binding var focused: Bool
    
    var body: some View {
        ScrollView {
            Headline(heading: "Reincarnation Type", subheading: "What kind of body is your soul going to inhabit?\nNote that adding an 'original character' who has lived in your chosen world for many years may cause many changes to canon events. However, by default this will have minimal impact. It's only when you're trying to force your way into a position where changes are inevitable that this becomes a bigger issue.")
            
            GridView {
                ForEach(incarnation["incarnationTypes"]!, id: \.self) { option in
                    Button {
                        character.setValue(for: &character.reincarnationType, from: option)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: option, selected: character.reincarnationType == option)
                    }
                    .buttonStyle(.plain)
                    .disabled(disableOption(current: option.title))
                }
            }
            .onChange(of: character.reincarnationType) {
                character.reset([\.gender, \.twin, \.familyMember, \.sex, \.appearance, \.family, \.homelife, \.education, \.job])
                character.reset([\.name, \.nickName, \.capeName, \.appearanceDesc, \.homelifeDesc, \.eduJobHistory])
                character.reset([\.age])
                character.extraFamily = []
                try? modelContext.save()
            }
            
            switch character.reincarnationType?.title {
            case "Original Character":
                OriginalCharacter(character: character, focused: $focused, incarnation: incarnation)
            case "Twin":
                Twin(character: character, focused: $focused, incarnation: incarnation)
            case "Family Member":
                FamilyMember(character: character, focused: $focused, incarnation: incarnation)
            default:
                EmptyView()
            }
        }
        .defaultScrollAnchor(.top)
    }
    
    func disableOption(current: String) -> Bool {
        var tempBool = true
        
        if character.setting?.title == "Canon Earth Bet" {
            tempBool = false
        }
        
        if current == "Original Character" {
            tempBool = false
        }
        
        return tempBool
    }
}

