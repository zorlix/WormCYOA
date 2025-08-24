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
    
    @State private var showingAlert = false
    @State private var tempString = ""
    var displayAge: String {
        if let age = character.age {
            return "\(age)"
        } else {
            return "N/A"
        }
    }
    
    var body: some View {
        Headline(heading: "Age", subheading: "How old is your body going to be when you awaken within it?\nIf you choose a particularly young or particularly old form, you will receive some extra points for it. After all, it may and likely will cause you some complications.\nAge 0 to 5 — Gain: 10 SP and 15 CP\nAge 6 to 9 — Gain: 7 SP and 10 CP\nAge 10 to 12 — Gain: 5 SP and 8 CP\nAge 13 to 18 – Gain: 5 CP\nAge 18 to 49 — You do not receive any points\nAge 50 to 69 — Cost: 5 SP, Gain: 20 CP\nAge 70+ — Cost: 8 SP, Gain: 30 CP")
        
        if let insert = character.overtakenIdentity {
            MinorHeadline(text: "Character-Insert")
            
            PureText("You've chosen to Character-Insert into the body of \(insert.title).\nAs stated before, this means that your age will be that character's age, and all data on the character's card assumes it's April 8, 2011.\nHowever, seeing as many scenarios can take you to different points on the timeline, your age might be different than what's written on the card. You can use the text field below to note down the age that your chosen character's body will be when you awaken within it.\nNote: If you've purposefully chosen a scenario prior to this character's birth, write 0. If you've chosen a scenario after their death, write down the age they were when they died. That will be the age their body will have after your reincarnation, regardless of how much time has passed since they died.")
            
            if character.perks.contains(where: { $0.title == "Cosmetic Shapeshift" }) {
                PureText("If you've taken the perk Cosmetic Shapeshift, you may choose your age freely.")
            }
        }
        
        if let twin = character.twin {
            MinorHeadline(text: "Twin")
            
            PureText("You've chosen to become the identical twin of \(twin.title).\nThis means that your age will be that character's age, and all data on the character's card assumes it's April 8, 2011.\nHowever, seeing as many scenarios can take you to different points on the timeline, your age might be different than what's written on the card. You can use the text field below to note down the age that your chosen character's body will be when you awaken within it.\nNote: If you've purposefully chosen a scenario prior to this character's birth, write 0. If you've chosen a scenario after their death, write down the age they were when they died. That will be the age their body will have after your reincarnation, regardless of how much time has passed since they died.")
            
            if character.perks.contains(where: { $0.title == "Cosmetic Shapeshift" }) {
                PureText("If you've taken the perk Cosmetic Shapeshift, you may choose your age freely.")
            }
        }
        
        if let famMember = character.familyMember {
            MinorHeadline(text: "Family Member")
            
            PureText("You've chosen to become a family member of \(famMember.title).\nAs stated before, you may choose exactly which family member you'll become as long as it's not the character's identical twin. Therefore, you may choose how old you'll be when you awaken in your new body.")
        }
        
        if character.incarnationMethod?.title == "Drop-In" && character.drawbacks.contains(where: { $0.title == "Pint Sized" }) {
            PureText("Warning: You've selected the drawback Pint Sized which will reduce your age to 6-12 years old. Normally, this is chosen at random, but with Cosmetic Shapeshift you may choose the exact age. You must remain within the bounds of 6-12 years old.")
        }
        
        MinorHeadline(text: "Your age:")
        
        PureText(displayAge)
            .font(.largeTitle.bold())
        
        ButtonView(title: "Change your age") {
            showingAlert = true
        }
        .alert("Your current age is \(displayAge)", isPresented: $showingAlert) {
            TextField("Enter new age", text: $tempString)
                .keyboardType(.decimalPad)
            
            Button("Save") {
                if let num = Int(tempString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    character.age = num
                    try? modelContext.save()
                    tempString = ""
                } else {
                    tempString = ""
                }
            }
            
            Button("Cancel", role: .cancel) {
                tempString = ""
            }
        } message: {
            Text("Enter your new age.")
        }
        
        PureText("Warning: If you have any character traits, perks, or drawbacks that have a certain age requirement, changing your age here to a number outside that requirement will automatically remove those items from your selection.")
            .onChange(of: character.age) {
                character.validateAgeReq()
                try? modelContext.save()
            }
    }
}
