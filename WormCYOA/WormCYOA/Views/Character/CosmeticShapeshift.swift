//
//  CosmeticShapeshift.swift
//  WormCYOA
//
//  Created by Josef Černý on 26.07.2025.
//

import SwiftData
import SwiftUI

struct CosmeticShapeshift: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let incarnation: [String: [Item]]
    
    var body: some View {
        Headline(heading: "Cosmetic Shapeshift", subheading: "You've taken the perk Cosmetic Shapeshift, and as such you may change your new body in any way you desire.\nWarning: Other will know you by your old appearance, and will react to your new form accordingly. This does not matter if you've chosen to be Dropped-In.")
        
        SexView(character: character, sexes: incarnation["sex"]!)
        
        AgeView(character: character, focused: $focused)
        
        AppearanceView(character: character, focused: $focused, appearances: incarnation["appearance"]!)
    }
}
