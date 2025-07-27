//
//  CharacterView.swift
//  WormCYOA
//
//  Created by Josef Černý on 09.07.2025.
//

import SwiftData
import SwiftUI

struct CharacterView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let incarnation: [String: [Item]] = Bundle.main.decode("characters.json")
    
    @FocusState var focused: Bool
    
    var body: some View {
        ScrollView {
            Headline(heading: "Character")
            
            NavigationLink {
                BasicCharacterInfo(character: character, genders: incarnation["genders"]!)
            } label: {
                VStack {
                    Text("Basic Character Info")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Name:").bold()
                        Text(character.name ?? "None")
                    }
                    
                    HStack {
                        Text("Nickname:").bold()
                        Text(character.nickName ?? "None")
                    }
                    
                    HStack {
                        Text("Gender:").bold()
                        Text(character.gender?.title ?? "None")
                    }
                    .padding(.bottom, 8)
                    
                    Text("Tap to change")
                        .font(.caption)
                        .italic()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white)
                )
                .padding(.bottom)
            }
            .buttonStyle(.plain)
            
            GridView {
                ForEach(incarnation["incarnationMethods"]!, id: \.title) { inc in
                    Button {
                        character.setValue(for: &character.incarnationMethod, from: inc)
                        try? modelContext.save()
                    } label: {
                        ItemView(item: inc, selected: character.incarnationMethod == inc)
                    }
                    .buttonStyle(.plain)
                    .disabled(disableOption(inc.title))
                }
            }
            .onChange(of: character.incarnationMethod) {
                character.reset([\.gender, \.overtakenIdentity, \.reincarnationType, \.twin, \.familyMember, \.sex, \.appearance, \.family, \.homelife, \.education, \.job])
                character.reset([\.name, \.nickName, \.capeName, \.appearanceDesc, \.homelifeDesc, \.eduJobHistory])
                character.reset([\.age])
                character.extraFamily = []
                try? modelContext.save()
            }
            
            switch character.incarnationMethod?.title {
            case "Character-Insert":
                CharacterInsert(character: character, focused: $focused, incarnation: incarnation)
                
            case "Reincarnation":
                Reincarnation(character: character, incarnation: incarnation, focused: $focused) // Get better image
                
            case "Drop–In":
                if character.setting?.title == "No Transfer" {
                    MinorHeadline(text: "No Transfer")
                    PureText("You've chosen to remain in your original universe. There are no characters you can choose to character-insert into because there are no characters at all in your world. Only real people. I know... boring.")
                }
                
                if character.perks.contains(where: { $0.title == "Cosmetic Shapeshift" }) {
                    CosmeticShapeshift(character: character, focused: $focused, incarnation: incarnation)
                }
                
            default:
                EmptyView()
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
        .onSubmit {
            try? modelContext.save()
            print("Saved")
        }
        .onChange(of: character.deletedItems) {
            character.validateRequirements()
            try? modelContext.save()
        }
    }
    
    func disableOption(_ string: String) -> Bool {
        var tempBool = true
        
        if string == "Reincarnation" || string == "Drop–In" {
            tempBool = false
        }
        
        if character.setting?.title == "Canon Earth Bet" {
            tempBool = false
        }
        
        return tempBool
    }
}
