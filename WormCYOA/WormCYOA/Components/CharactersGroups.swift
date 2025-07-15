//
//  CharactersGroups.swift
//  WormCYOA
//
//  Created by Josef Černý on 10.07.2025.
//

import SwiftUI

struct CharactersGroups: View {
    let selectedItem: Item?
    let characters: [String: [Item]]

    let buttonAction: (Item) -> Void
    
    var body: some View {
        GridView {
            ForEach(characters["groups"]!, id: \.title) { group in
                if let members = characters[group.title] {
                    NavigationLink {
                        ScrollView {
                            Characters(title: group.title, selectedItem: selectedItem, characters: members, shouldDismiss: true) { member in
                                buttonAction(member)
                            }
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .contentMargins(30, for: .scrollContent)
                    } label: {
                        ItemView(item: group)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
