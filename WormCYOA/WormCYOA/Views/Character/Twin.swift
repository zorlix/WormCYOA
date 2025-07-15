//
//  Twin.swift
//  WormCYOA
//
//  Created by Josef Černý on 13.07.2025.
//

import SwiftData
import SwiftUI

struct Twin: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let incarnation: [String: [Item]]
    
    var body: some View {
        Headline(heading: "Twin", subheading: "You've chosen to go to Earth Bet, and you've chosen to become an identical twin of an existing character from this universe. Who will it be?\nAll data is assuming it's April 8, 2011.\nBe warned that if you've chosen a Scenario prior to the day this character was born, the character's — and obviously also yours — birthday will remain the same. Your mind will only awaken in this worlds when your reborn self becomes self-aware.\nIf you've chosen a Scenario after your chosen character's death, they will absolutely still be dead. You'll just be their surviving twin.\nMuch like an Original Character, this type of reincarnation is absolutely safe and seamless. You will have always been a part of this character's life, you'll belong there.\nIf your selected character is a parahuman, you may choose to share their Shard and power. In such a case, you will have shared your trigger event as well. You will be just like Fenja and Menja.\nHowever, you may also choose to have a different trigger event which would result in a different (though, maybe somewhat similar) power — you will have a bud of their Shard.\nNote that you will not be able to choose your sex, age, and appearance as you will be sharing them with your twin. Therefore, if your consciousness is not compatible with your new body, you may start experiencing some gender dysphoria. You may want to use the options above to change your gender, should it differ from the sex of your new body.")
        
        if let twin = character.twin {
            ItemView(item: twin, selected: true)
            
            ButtonView(title: "Choose someone else") {
                character.reset([\.twin, \.familyMember, \.gender, \.homelife, \.education, \.job])
                character.reset([\.name, \.nickName, \.capeName, \.homelifeDesc, \.eduJobHistory])
                character.reset([\.age])
                character.extraFamily = []
                try? modelContext.save()
            }
        } else {
            switch character.setting?.title {
            case "Canon Earth Bet":
                CharactersGroups(selectedItem: character.twin, characters: Bundle.main.decode("worm.json") as [String: [Item]]) { char in
                    character.setValue(for: &character.twin, from: char)
                    try? modelContext.save()
                }
                
            default: EmptyView()
            }
        }
        
        AgeView(character: character, focused: $focused)
        
        EducationView(character: character, education: incarnation["education"]!)
        
        JobView(character: character, jobs: incarnation["jobs"]!)
        
        EduJobHistoryView(character: character, focused: $focused)
        
        ExtraFamilyView(character: character, extraFamily: incarnation["extraFamily"]!)
        
        HomelifeView(character: character, focused: $focused, homelife: incarnation["homelife"]!)
    }
    
    
}
