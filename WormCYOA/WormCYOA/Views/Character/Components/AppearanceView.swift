//
//  AppearanceView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct AppearanceView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let appearances: [Item]
    
    var body: some View {
        Headline(heading: "Appearance", subheading: "How good-looking is your new body going to be?\nFor the most part you won't get a choice in what it'll look like. Far too many people blindly chose to transform themselves into what they considered attractive only to immediately start suffering from dismorphia. Therefore, your new body will be chosen for you based on what will be the best fit for you consciousness. This section will only decide how attractive your new form will be. However, you may still (in the text field below) specify some details of your new form. Things like hair color, eyes color, and skin color are up to you. Or you may not write anything and leave it up to chance.\nSeeing as attraction and beauty are not exactly objective, this will work off of your own beauty standards. So, 'Ideal' form would give you a body that you would consider ideal, and 'Hideous' would do the opposite. This does not necessarily mean that everyone else will see you that way.\nYou are for the most part guaranteed to retain your chosen form. Your body might change somewhat due to certain factors like diet or age, but in general your appearance won't stray from what you choose below.\nFor example, let's say you choose to take an Ideal body. Then if you do not consider more heavyset forms to be the peak of beauty, you will never gain too much weight. You will still age, but you will always look amazing for your age. Because of this, you are unlikely to be afflicted by any illness that might change or damage your body.\nWarning: This does not mean you will forever remain healthy. Bad diet might be less unhealthy for you because you won't gain too much weight, but that will not prevent vitamin deficiency, high cholesterol or any number of far more serious conditions.\nThis will also not protect you from any external factors that might damage or change your body and appearance. A cut will still result in a scar that will mar your body, though with an Ideal or Attractive form, it might not be quite as bad as it'd be otherwise. A burn will do the same. If you piss off a crazed biokinetic, they can still absolutely warp your body into a giant Cronenberg monster. These perks only apply to natural factors affecting your form.\nOn the other hand, this means that you can still have your appearance changed with the help of plastic surgery or parahuman ability, yours or another's.")
        
        GridView {
            ForEach(appearances, id: \.title) { app in
                Button {
                    character.setValue(for: &character.appearance, from: app)
                    try? modelContext.save()
                } label: {
                    ItemView(item: app, selected: character.appearance == app)
                }
                .buttonStyle(.plain)
            }
        }
        
        MinorHeadline(text: "Details")
        
        let appDesc = Binding<String>(
            get: { character.appearanceDesc ?? "" },
            set: { newValue in
                character.appearanceDesc = newValue.isEmpty ? nil : newValue
            }
        )
        TextField("Details", text: appDesc)
            .textfieldStyle()
            .focused($focused)
    }
}
