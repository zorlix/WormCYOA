//
//  DeviantView.swift
//  WormCYOA
//
//  Created by Josef Černý on 18.08.2025.
//

import SwiftData
import SwiftUI

struct DeviantView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let deviantForms: [Item] = Bundle.main.decode("deviants.json")
    
    var body: some View {
        ScrollView {
            Headline(heading: "Deviant Form", subheading: "You've taken the Deviant drawback, and in this tab, you can choose what your mutated form will be from a list of 100 possibilities.\nYou can browse the list and select the form you want; milder mutations may cost points, while choosing a debilitating form will grant you bonus points.\nAlternatively, for the 'authentic' deviant cape experience, you can let chance decide. If you choose to roll, you'll receive a set amount of bonus points regardless of the result. This is a gamble: you might get a powerful form that would normally cost points, or you could get a terrible one and receive less than if you had picked it directly.\nYou can choose to reroll your result, though each attempt costs progressively more points.\nThe list is categorized by severity. Minor mutations (15 forms) leave your body mostly human. Severe mutations (20 forms) involve more extreme changes, but you are still recognizably human. Non-human forms (40 forms) are the bulk of the list and will transform you into something alien. Debilitating forms (15 forms) come with severe disadvantages, while critical failures (5 forms) are truly terrible mutations that will leave you severely handicapped. Finally, the jackpots (5 forms), while still alien, can be considered vast improvements over a normal human body and come with powerful abilities.") 
            
            if let localForm = character.deviantForm {
                if character.deviantRolledRandomly {
                    MinorHeadline(text: "Your rolled form")
                    
                    ItemView(item: localForm)
                        .padding(.bottom)
                    
                    MinorHeadline(text: "Reroll")
                    
                    PureText("You can reroll if you're not satisfied with your result. However, each reroll costs progressively more points. If you later decide to remove the Deviant drawback entirely, you will *not* be charged for any rerolls you've made. Note that removing and re-adding the drawback will not reset this cost.\nYou can also use this button to manually select a form after rolling, but doing so will not refund any points spent on rerolls.")
                    
                    ItemView(item: Item(title: "Reroll Costs", desc: "**Points spent on rerolls:** \(character.reRoll.SPCost ?? 0) SP, \(character.reRoll.CPCost ?? 0) CP\n**Next reroll will add:** \(nextSPValue()) SP and \(nextCPValue()) CP"))
                    
                    ButtonView(title: "Reroll") {
                        reRollIt()
                    }
                } else {
                    MinorHeadline(text: "Your chosen form")
                    
                    ItemView(item: localForm)
                        .padding(.bottom)
                    
                    if character.reRoll.SPCost != 0 && character.reRoll.CPCost != 0 {
                        MinorHeadline(text: "Extra costs")
                        
                        PureText("You previously rolled for a random form, but then used a reroll to choose one manually. The cost for the reroll still applies.\n**Amount Owed:** \(character.reRoll.SPCost ?? 0) SP and \(character.reRoll.CPCost ?? 0) CP")
                    }
                    
                    ButtonView(title: "Choose something else") {
                        character.reset([\.deviantForm])
                        try? modelContext.save()
                    }
                }
            } else {
                Button(action: randomRoll) {
                    ItemView(item: Item(title: "Random Roll", SPGain: 22, CPGain: 37, desc: "Roll for a random form."))
                }
                .buttonStyle(.plain)
                .padding(.bottom)
                
                MinorHeadline(text: "Select a form")
                
                GridView {
                    ForEach(deviantForms, id: \.self) { form in
                        Button {
                            character.setValue(for: &character.deviantForm, from: form)
                            try? modelContext.save()
                        } label: {
                            ItemView(item: form, selected: character.deviantForm == form)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
    }
    
    func randomRoll() {
        var randomForm = deviantForms.randomElement()
        randomForm?.SPGain = 22
        randomForm?.CPGain = 37
        randomForm?.SPCost = nil
        randomForm?.CPCost = nil
        character.deviantForm = randomForm
        character.deviantRolledRandomly = true
        try? modelContext.save()
    }
    
    func reRollIt() {
        character.deviantForm = nil
        character.deviantRolledRandomly = false
        
        character.reRoll.SPCost = nextSPValue()
        character.reRoll.CPCost = nextCPValue()
        
        try? modelContext.save()
    }
    
    func nextSPValue() -> Int {
        let current = character.reRoll.SPCost ?? 0
        
        if current == 0 {
            return 5
        } else {
            return current + 10
        }
    }
    
    func nextCPValue() -> Int {
        let current = character.reRoll.CPCost ?? 0
        
        if current == 0 {
            return 5
        } else {
            return current + 10
        }
    }
}


/*
 Humanoid starts with  Chromatophore Skin and ends with Catalytic Hemolymph
 Transformed starts with Ferrous Form and ends with Salt Form
 Signifanctly alien starts with Panopticon Swarm and ends with Wraith Core
 Severely debilitating starts with Aberrant Gestation and ends with The Composer
 Life-destroying starts with The God-Flesh and ends with  The Moment
 Jackpot starts with The Conductor and ends at the end
 */

