//
//  BasicCharacterInfo.swift
//  WormCYOA
//
//  Created by Josef Černý on 09.07.2025.
//

import SwiftData
import SwiftUI

struct BasicCharacterInfo: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState var focused: Bool
    
    let genders: [Item]
    
    var body: some View {
        ScrollView {
            Headline(heading: "Basic Character Info")
            
            VStack {
                MinorHeadline(text: "Name")
                let name = Binding<String>(
                    get: { character.name ?? "" },
                    set: { newValue in
                        character.name = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Character Name", text: name, axis: .vertical)
                    .textfieldStyle()
                    .focused($focused)
            }
            
            VStack {
                MinorHeadline(text: "Cape Name")
                let capeName = Binding<String>(
                    get: { character.capeName ?? "" },
                    set: { newValue in
                        character.capeName = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Cape Name", text: capeName, axis: .vertical)
                    .textfieldStyle()
                    .focused($focused)
            }
            
            VStack {
                MinorHeadline(text: "Nickname")
                let nickname = Binding<String>(
                    get: { character.nickName ?? "" },
                    set: { newValue in
                        character.nickName = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Nickname", text: nickname, axis: .vertical)
                    .textfieldStyle()
                    .focused($focused)
            }
            
            Headline(heading: "Gender", subheading: "Your new body is going to be created to be a perfect fit for your consciousness. With one exception: You are free to choose to reincarnate as any sex you want, you can also character-insert into both men and women. This might cause problems if your gender is different from your sex.\nDo you wish to tweak your consciousness a little so as to change your gender identity?")
            GridView {
                ForEach(genders, id: \.title) { gender in
                    Button {
                        character.setValue(for: &character.gender, from: gender)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: gender, selected: character.gender == gender)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            VStack {
                Headline(heading: "Notes", subheading: "Do you wish to note down some information about the character? What are your plans for the future? What's your character's backstory (obviously within the confines of your choices)?\nAnything and everything about your character that you want to note down, you may do so right here.\nPlease don't use this to note down things about your powers. There will be a separate text field for that in the future.")
                let notes = Binding<String>(
                    get: { character.characterInfo ?? "" },
                    set: { newValue in
                        character.characterInfo = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Character Info", text: notes, axis: .vertical)
                    .textfieldStyle()
                    .focused($focused)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Hide keyboard", systemImage: "keyboard.chevron.compact.down") {
                    focused = false
                    try? modelContext.save()
                    print("Saved")
                }
            }
        }
        .onSubmit {
            try? modelContext.save()
            print("Saved")
        }
    }
}
