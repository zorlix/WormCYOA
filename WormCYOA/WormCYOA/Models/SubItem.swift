//
//  SubItem.swift
//  WormCYOA
//
//  Created by Josef Černý on 04.08.2025.
//

import SwiftUI

struct SubItem: Codable, Hashable {
    let title: String
    let synergy: String
    var incompatibility: String? = nil 
    var comment: String? = nil
    let desc: String
    var isSelected: Bool? = nil
    
    static let example = SubItem(title: "Testing SubItem", synergy: "Genius", desc: "Here be the description.")
}
