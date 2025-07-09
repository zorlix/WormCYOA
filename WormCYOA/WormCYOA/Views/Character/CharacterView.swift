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
            
            Button("Nullify") {
                character.name = nil
                character.nickName = nil
                character.capeName = nil
                character.gender = nil
                character.characterInfo = nil
                character.incarnationMethod = nil
            }
            
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
            
            switch character.incarnationMethod?.title {
            case "Character-Insert":
                Text("kk")
            case "Reincarnation":
                Text("kk")
            case "Drop–In":
                Text("kk")
            default:
                EmptyView()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
    }
    
    func disableOption(_ string: String) -> Bool {
        if string == "Drop–In" {
            return false
        } else {
            if character.setting?.title == "No Transfer" {
                return true
            }
        }
        
        return false
    }
}
