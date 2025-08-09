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
            
            if let identity = character.overtakenIdentity {
                MinorHeadline(text: "Character-Insert")
                
                ItemView(item: identity)
                
                PureText("You've chosen to Character-Insert into \(identity.title). This means that you'll asume the position of this character in your selected universe. Their name will be your name, their history will be your history, and their cape name will be your cape name.\nAfter your arrival, you're of course welcome to change what you wish.\nPlease fill the text fields below with relevant information to from your selected character's card.\nWarning: Filling in incorrect information might result in changes in your chosen world.")
            }
            
            if let twin = character.twin {
                MinorHeadline(text: "Twin")
                
                ItemView(item: twin)
                
                PureText("You've chosen to reincarnate as an identical twin of \(twin.title). Because this is a Reincarnation as opposed to Character-Insertion, canon events will be ever so slightly adjusted so as to accomodate your presence in this character's family. By default, the changes to canon are going to be as minor as possible.\nSeeing as you will be your own person, you are allowed to choose your own name. However, consider choosing the same last name as this character. Doing otherwise may alter your character's backstory to make sense of two siblings — twins, at that — having a different last name.")
            }
            
            if let familyMember = character.familyMember {
                MinorHeadline(text: "Family Member")
                
                ItemView(item: familyMember)
                
                PureText("You've chosen to reincarnate as a family member of \(familyMember.title). You may decide what exact familial relationship you will have. Because of this, you may choose whichever name you want, though if your relationship dictates that you should share last name (e.g., you are sisters, the character is your child, etc.), it is recommended that you do so. Doing otherwise may alter your character's backstory to make sense of two close family members having different last names.")
            }
            
            VStack {
                MinorHeadline(text: "Name")
                let name = Binding<String>(
                    get: { character.name ?? "" },
                    set: { newValue in
                        character.name = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Character name", text: name, axis: .vertical)
                    .textfieldStyle()
                    .focused($focused)
            }
            
            VStack {
                MinorHeadline(text: "Cape name")
                let capeName = Binding<String>(
                    get: { character.capeName ?? "" },
                    set: { newValue in
                        character.capeName = newValue.isEmpty ? nil : newValue
                    }
                )
                TextField("Cape name", text: capeName, axis: .vertical)
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
            
            Headline(heading: "Gender", subheading: "Your new body is going to be created to be a perfect fit for your consciousness. With one exception: You are free to choose to reincarnate as any sex you want, you can also Character-Insert into both men and women. This might cause problems if your gender is different from your sex.\nDo you wish to tweak your consciousness a little so as to change your gender identity?")
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
                    get: { character.characterNotes ?? "" },
                    set: { newValue in
                        character.characterNotes = newValue.isEmpty ? nil : newValue
                    }
                )
                TextEditor(text: notes)
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
