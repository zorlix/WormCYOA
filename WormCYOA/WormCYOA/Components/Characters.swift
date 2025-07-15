//
//  Characters.swift
//  WormCYOA
//
//  Created by Josef Černý on 10.07.2025.
//

import SwiftUI

struct Characters: View {
    let title: String
    let selectedItem: Item?
    let characters: [Item]
    var shouldDismiss: Bool = false
    
    let buttonAction: (Item) -> Void
    @Environment(\.dismiss) var dismiss
 
    var body: some View {
        Headline(heading: title)
        GridView {
            ForEach(characters, id: \.title) { character in
                Button {
                    buttonAction(character)
                    if shouldDismiss {
                        dismiss()
                    }
                } label: {
                    ItemView(item: character, selected: selectedItem == character)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
