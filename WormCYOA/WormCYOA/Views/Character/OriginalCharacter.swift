//
//  OriginalCharacter.swift
//  WormCYOA
//
//  Created by Josef Černý on 13.07.2025.
//

import SwiftData
import SwiftUI

struct OriginalCharacter: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let incarnation: [String: [Item]]
    
    var body: some View {
        Headline(heading: "Original Character", subheading: "You've chosen to reincarnate as an original character. You will not be related to any known canon character. Your character creation options are not limited in any way.")
        
        SexView(character: character, sexes: incarnation["sex"]!)
        
        AgeView(character: character, focused: $focused)
        
        AppearanceView(character: character, focused: $focused, appearances: incarnation["appearance"]!)
        
        EducationView(character: character, education: incarnation["education"]!)
        
        JobView(character: character, jobs: incarnation["jobs"]!)
        
        EduJobHistoryView(character: character, focused: $focused)
        
        FamilyView(character: character, familySituations: incarnation["family"]!)
        
        ExtraFamilyView(character: character, extraFamily: incarnation["extraFamily"]!)
        
        HomelifeView(character: character, focused: $focused, homelife: incarnation["homelife"]!)
    }
}
