//
//  AgeView.swift
//  WormCYOA
//
//  Created by Josef Černý on 13.07.2025.
//

import SwiftData
import SwiftUI

struct AgeView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    var body: some View {
        Headline(heading: "Age", subheading: "How old is your body going to be when you awaken within it?\nIf you choose a particularly young or particularly old form, you will receive some extra points for it. After all, it may and likely will cause you some complications.\nAge 0 to 5 — Gain: 10 SP\nAge 6 to 9 — Gain: 7 SP\nAge 10 to 12 — Gain: 5 SP\nAge 13 to 49 — You do not receive any points\nAge 50 to 69 — Gain: 2 SP, Gain: 5 CP\nAge 70+ — Gain: 5 SP, Gain: 10 CP")
        
        if let insert = character.overtakenIdentity {
            MinorHeadline(text: "Character-Insert")
            
            PureText("You've chosen to character-insert into the body of \(insert.title).\nAs stated before, this means that your age will be that character's age, and all data on the character's card assumes it's April 8, 2011.\nHowever, seeing as many scenarios can take you to different points on the timeline, your age might be different than what's written on the card. You can use the text field below to note down the age that your chosen character's body will be when you awaken within it.\nNote: If you've purposefully chosen a Scenario prior to this character's birth, write 0. If you've chosen a Scenario after their death, write down the age they were when they died. That will be the age their body will have after your reincarnation, regardless of how much time has passed since they died.")
        }
        
        if let twin = character.twin {
            MinorHeadline(text: "Twin")
            
            PureText("You've chosen to become the identical twin of \(twin.title).\nThis means that your age will be that character's age, and all data on the character's card assumes it's April 8, 2011.\nHowever, seeing as many scenarios can take you to different points on the timeline, your age might be different than what's written on the card. You can use the text field below to note down the age that your chosen character's body will be when you awaken within it.\nNote: If you've purposefully chosen a Scenario prior to this character's birth, write 0. If you've chosen a Scenario after their death, write down the age they were when they died. That will be the age their body will have after your reincarnation, regardless of how much time has passed since they died.")
        }
        
        if let famMember = character.familyMember {
            MinorHeadline(text: "Family Member")
            
            PureText("You've chosen to become a family member of \(famMember.title).\nAs stated before, you may choose exactly which family member you'll become as long as it's not the character's identical twin. Therefore, you may choose how old you'll be when you awaken in your new body.")
        }
        
        MinorHeadline(text: "You Age")
        
        let age = Binding<String>(
            get: {
                if let age = character.age {
                    String(age)
                } else {
                    ""
                }
            },
            set: { newVaue in
                if let int = Int(newVaue) {
                    character.age = int
                } else {
                    character.age = nil
                }
            }
        )
        TextField("Character Age", text: age)
            .textfieldStyle(numbersOnly: true)
            .focused($focused)
            .onChange(of: character.age) {
                character.reset([\.education, \.job])
                character.reset([\.eduJobHistory])
                character.extraFamily = []
                try? modelContext.save()
            }
    }
}
