//
//  HomelifeView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct HomelifeView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool
    
    let homelife: [Item]
    
    var body: some View {
        Headline(heading: "Homelife", subheading: "What is your life going to be like outside of education/work/cape business?\nHow  will you get along with your family? Are the most important relationships in your life going to be healthy?\nThese options will apply even if you've chosen to reincarnate your old family along with you. They may be used to change what your homelife is like in either direction.")
        
        GridView {
            ForEach(homelife, id: \.title) { homelife in
                Button {
                    character.setValue(for: &character.homelife, from: homelife)
                    try? modelContext.save()
                } label: {
                    ItemView(item: homelife, selected: character.homelife == homelife)
                }
                .buttonStyle(.plain)
                .disabled(character.isReqMet(of: homelife))
            }
        }
        
        MinorHeadline(text: "Homelife Details")
        PureText("Here you may describe what your homelife will be like and the details of your new family's situation.\nNote that your notes here will be ignored if they contradict your choices above.")
        
        let homeDesc = Binding<String>(
            get: { character.homelifeDesc ?? "" },
            set: { newValue in
                character.homelifeDesc = newValue.isEmpty ? nil : newValue
            }
        )
        TextField("Details", text: homeDesc)
            .textfieldStyle()
            .focused($focused)
    }
}
