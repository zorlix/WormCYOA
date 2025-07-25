//
//  ExtraFamilyView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct ExtraFamilyView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let extraFamily: [Item]
    
    var body: some View {
        Headline(heading: "Extra Family", subheading: "Do you wish to have some extra family members? Do you wish to have some siblings or cousins? Perhaps you're old enough and you have a wife of your own, or even children.\nNote: If you've chosen to character-insert into a canon character, or if you've chosen to become a twin or a family member of a canon character, these choices may result in significant changes to the family's dynamic.")
        
        GridView {
            ForEach(extraFamily, id: \.title) { family in
                Group {
                    if family.count != nil {
                        ItemView(item: character.displayCountedItem(family, forArr: character.extraFamily), selected: character.isItemSelected(family, inArr: character.extraFamily), increase: {
                            character.changeCount(of: family, in: &character.extraFamily, action: .increase)
                            try? modelContext.save()
                        }, decrease: {
                            character.changeCount(of: family, in: &character.extraFamily, action: .decrease)
                            try? modelContext.save()
                        })
                    } else {
                        Button {
                            character.setValue(for: &character.extraFamily, from: family)
                            try? modelContext.save()
                        } label: {
                            ItemView(item: family, selected: character.extraFamily.contains(family))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .disabled(character.isReqMet(of: family))
            }
        }
    }
}
