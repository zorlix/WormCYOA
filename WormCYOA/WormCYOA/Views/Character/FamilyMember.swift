//
//  FamilyMember.swift
//  WormCYOA
//
//  Created by Josef Černý on 13.07.2025.
//

import SwiftData
import SwiftUI

struct FamilyMember: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let incarnation: [String: [Item]]
    
    var body: some View {
        Headline(heading: "Family Member", subheading: "You've chosen to go to Earth Bet, and you've chosen to become a family member of an existing character from this universe. Who will it be?\nAll data is assuming it's April 8, 2011.\nYou may choose what your exact relationship with this character will be.\nUnlike with the Twin Reincarnation type, you'll only be related to this character, you do not have to be the same age. So, if you choose scenario prior to the character's birth, you will simply be their older relative and will wake up exactly when the time of the scenario comes.\nMuch like an Original Character, this type of reincarnation is absolutely safe and seamless. You will have always been a part of this character's life, you'll belong there.\nIf your selected character is a parahuman, you will have access to a bud of their Shard, providing you with a somewhat similar power.\nGiven that you've elected to reincarnate only as your chosen character's family member as opposed to their twin, we have much greater leeway to providing you with a body fitting for your consciousness. You will be able to choose your new sex, age, and appearance.")
        
        if let familyMember = character.familyMember {
            ItemView(item: familyMember, selected: true)
            
            ButtonView(title: "Choose someone else") {
                character.reset([\.gender, \.familyMember, \.sex, \.appearance, \.homelife, \.education, \.job])
                character.reset([\.name, \.nickName, \.capeName, \.appearanceDesc, \.homelifeDesc, \.eduJobHistory])
                character.reset([\.age])
                character.extraFamily = []
                try? modelContext.save()
            }
        } else {
            switch character.setting?.title {
            case "Canon Earth Bet":
                CharactersGroups(selectedItem: character.familyMember, characters: Bundle.main.decode("worm.json") as [String: [Item]]) { char in
                    character.setValue(for: &character.familyMember, from: char)
                    try? modelContext.save()
                }
                
            default:
                EmptyView()
            }
        }
        
        SexView(character: character, sexes: incarnation["sex"]!)
        
        AgeView(character: character, focused: $focused)
        
        AppearanceView(character: character, focused: $focused, appearances: incarnation["appearance"]!)
        
        EducationView(character: character, education: incarnation["education"]!)
        
        JobView(character: character, jobs: incarnation["jobs"]!)
        
        EduJobHistoryView(character: character, focused: $focused)
        
        ExtraFamilyView(character: character, extraFamily: incarnation["extraFamily"]!)
        
        HomelifeView(character: character, focused: $focused, homelife: incarnation["homelife"]!)
    }
}
