//
//  EducationView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct EducationView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let education: [Item]
    
    var body: some View {
        Headline(heading: "Education", subheading: "What is your level of education?\nAre you currently studying? Have you graduated already and don't plan on pursuing any further education?\nAll higher tiers assume that you have graduated from the lower tiers.\nYou will be granted all the skills and knowledge you would have gained through your education.")
        
        if character.overtakenIdentity != nil {
            PureText("You've chosen to Character-Insert into a canon character. That means that you must respect the life they've led up until the point of your awakening in their body. However, should you choose to arrive at some point on the timeline after April 8, 2011, you may find that your chosen character achieved some extra education or gained a job. So, you may use the choices below the specify what that should be.\nWarning: You choices will be ignored if they contradict what we know about said character prior to April 8, 2011. Please try to select something that would be in-character.\nNote: You may also use this if you've chosen a character who we don't know much about. For example, if their achived education is not known, your choices here will apply.")
        }
        
        GridView {
            ForEach(education, id: \.title) { edu in
                Button {
                    character.setValue(for: &character.education, from: edu)
                    try? modelContext.save()
                } label: {
                    ItemView(item: edu, selected: character.education == edu)
                }
                .buttonStyle(.plain)
                .disabled(character.isReqMet(of: edu))
            }
        }
    }
}
