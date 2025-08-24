//
//  CharacterInsert.swift
//  WormCYOA
//
//  Created by Josef Černý on 10.07.2025.
//

import SwiftData
import SwiftUI

struct CharacterInsert: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let incarnation: [String: [Item]]
    
    var body: some View {
        if let setting = character.setting {
            switch setting.title {
            case "Canon Earth Bet":
                Headline(heading: "Identity", subheading: "You've chosen to go to Earth Bet, and you've chosen to Character-Insert into someone from this universe. Who will it be?\nAll data is assuming it's April 8, 2011.\nIf you've chosen a scenario prior to the time the individual becomes self-aware, which usually happens when they are about 4 years old, you will not take over until that time. The brain is simply not developed enough to support adult consciousness. Be warned that while your mind will largely remain your own after insertion, your body will still be that of a young child, and that will inevitably affect you.\nIf you choose to Character-Insert into your chosen character after their death, it'll work. You'll wake up near the location of (what's left of) the body. Good luck explaining that one!\nWarning: If you Character-Insert into a member of the Protectorate or New Wave, your presence might be easily discovered. For example, Gallant might suddenly become unable to read your emotions, or Panacea might notice the differences in your brain's physiology (of which there will undoubtedly be many). This might lead them to unfortunate conclusions; they might consider you a Stranger only pretending to be the original person, or they might assume you've been mastered.")
                
                if let identity = character.overtakenIdentity {
                    ItemView(item: identity, selected: true)
                    
                    ButtonView(title: "Choose someone else") {
                        character.reset([\.overtakenIdentity, \.gender, \.homelife, \.education, \.job])
                        character.reset([\.name, \.nickName, \.capeName, \.homelifeDesc, \.eduJobHistory])
                        character.reset([\.age])
                        character.extraFamily = []
                        try? modelContext.save()
                    }
                } else {
                    CharactersGroups(selectedItem: character.overtakenIdentity, characters: Bundle.main.decode("worm.json") as [String: [Item]]) { char in
                        character.setValue(for: &character.overtakenIdentity, from: char)
                        try? modelContext.save()
                    }
                }
                
            case "Alternate World":
                PureText("Apologies, but the wider multiverse will become available at a later date. You may still go with a custom characters, but Character-Inserts and relationships aren't available yet.")
            
            case "Crossover":
                PureText("Apologies, but the wider multiverse will become available at a later date. You may still go with a custom characters, but Character-Inserts and relationships aren't available yet.")
                
            default:
                EmptyView()
            }
            
            if character.overtakenIdentity != nil {
                AgeView(character: character, focused: $focused)
                
                EducationView(character: character, education: incarnation["education"]!)
                
                JobView(character: character, jobs: incarnation["jobs"]!)
                
                EduJobHistoryView(character: character, focused: $focused)
                
                ExtraFamilyView(character: character, extraFamily: incarnation["extraFamily"]!)
                
                HomelifeView(character: character, focused: $focused, homelife: incarnation["homelife"]!)
                
                if character.perks.contains(where: { $0.title == "Cosmetic Shapeshift" }) {
                    CosmeticShapeshift(character: character, focused: $focused, incarnation: incarnation)
                }
            }
        }
    }
}
