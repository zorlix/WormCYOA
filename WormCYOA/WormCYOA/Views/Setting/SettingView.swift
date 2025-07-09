//
//  SettingView.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftData
import SwiftUI

struct SettingView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let settings: [String: [Item]] = Bundle.main.decode("setting.json")
    
    @FocusState var focused: Bool
    
    var body: some View {
        ScrollView {
            Headline(heading: "Setting")
            GridView {
                ForEach(settings["basic"]!, id: \.title) { setting in
                    Button {
                        character.setValue(for: &character.setting, from: setting)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: setting, selected: character.setting == setting)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom)
            }
            
            if let setting = character.setting {
                switch setting.title {
                case "Canon Earth Bet":
                    SettingViewEarthBet(character: character, settings: settings)
                case "Alternate World":
                    Text("Coming later")
                case "Crossover":
                    Text("Coming later") // Figure out locations
                case "No Transfer":
                    MinorHeadline(text: "Staying home?")
                    PureText("You're choosing to remain in your own world? Then you're going to receive your chosen abilities soon after finishing this CYOA, but you'll remain where you are.\nIf you still wish to explore the multiverse from the comfort of your home, then be sure to pick up relevant abilities that'd allow you to travel outside of your universe.\nYou will also not be able to character-insert into another character nor will you be allowed to be reincarnated in a new form. You will retain your own body.")
                default:
                    EmptyView()
                }
                
                Group {
                    Button {
                        character.auElements.toggle()
                        try? modelContext.save()
                    } label: {
                        ItemView(item: Item(title: "AU Elements", desc: "Instead of arriving on your chosen world's main continuity, you will enter an alternative timeline. You may alter the world in many interesting ways as long as it does not contradict your chosen options above. For example, if you chose 'Crossover' above, you may not effectively eliminate one of your chosen settings.\nOtherwise, you may alter the world in any way you desire. For example, you may make every Parahuman a low-level Brute, so that nobody is extremely fragile. Or you can even use this to enter a version of your chosen world that comes from a fanfiction. Your choice."), selected: character.auElements == true)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                    
                    let auDesc = Binding<String>(
                        get: { character.auDesc ?? "" },
                        set: { newValue in
                            character.auDesc = newValue.isEmpty ? nil : newValue
                        }
                    )
                    if character.auElements {
                        VStack {
                            TextField("AU Description", text: auDesc, axis: .vertical)
                                .textfieldStyle()
                                .focused($focused)
                                .onSubmit {
                                    try? modelContext.save()
                                    print("Saved")
                                }
                        }
                    }
                }
                .onChange(of: character.auElements) { _, newValue in
                    if newValue == false {
                        character.auDesc = nil
                        try? modelContext.save()
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done", systemImage: "keyboard.chevron.compact.down") {
                    focused = false
                    try? modelContext.save()
                    print("Saved")
                }
            }
        }
        .onChange(of: character.setting) {
            character.reset([\.location, \.scenario, \.timeShift])
            try? modelContext.save()
        }
    }
}
