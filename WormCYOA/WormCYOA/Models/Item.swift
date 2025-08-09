//
//  Item.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftUI

struct Item: Codable, Equatable, Comparable, Hashable {
    let title: String
    var count: Int?
    let SPCost: Int?
    let CPCost: Int?
    let SPGain: Int?
    let CPGain: Int?
    let incompatibility: String?
    let requirement: String?
    let comment: String?
    let desc: String
    let image: String?
    let subItems: [SubItem]?
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        lhs.title == rhs.title
    }
    
    static func <(lhs: Item, rhs: Item) -> Bool {
        lhs.title < rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    init(title: String, count: Int? = nil, SPCost: Int? = nil, CPCost: Int? = nil, SPGain: Int? = nil, CPGain: Int? = nil, incompatibility: String? = nil, requirement: String? = nil, comment: String? = nil, desc: String, image: String? = nil, subItems: [SubItem]? = nil) {
        self.title = title
        self.count = count
        self.SPCost = SPCost
        self.CPCost = CPCost
        self.SPGain = SPGain
        self.CPGain = CPGain
        self.incompatibility = incompatibility
        self.requirement = requirement
        self.comment = comment
        self.desc = desc
        self.image = image
        self.subItems = subItems
    }
    
    static let example = Item(title: "Title", count: 3, SPCost: 2, CPCost: 2, SPGain: 2, CPGain: 2, incompatibility: "Here might be a longer amount of text.", requirement: "Some other item", comment: "'Fuck you,' – Socrates", desc: "This will be the longest amount of text ever. I don't know how long exactly, but usually at least a few paragraphs.\nAnd let's continue writing some example text. Let's see how this looks like.", image: "https://images.unsplash.com/photo-1724311564236-e14a0fd831ef?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
}
