//
//  Power.swift
//  WormCYOA
//
//  Created by Josef Černý on 29.08.2025.
//

import SwiftUI

enum PowerClassification: String, Codable, CaseIterable {
    case Mover, Shaker, Brute, Breaker, Master, Tinker, Blaster, Thinker, Striker, Changer, Trump, Stranger
}

enum PowerCategory: String, Codable, CaseIterable {
    case basePower = "Base Power"
    case powerCopy = "Power Copy"
    case upgrade = "Power Upgrade"
    case fusion = "Power Fusion"
    case universal = "Universal Upgrade"
}

struct Power: Codable, Equatable, Comparable, Hashable {
    let category: PowerCategory
    let tier: Int?
    let classifications: [PowerClassification]
    let details: Item // the power itself
    
    static func ==(lhs: Power, rhs: Power) -> Bool {
        lhs.details.title == rhs.details.title
    }
    
    static func <(lhs: Power, rhs: Power) -> Bool {
        lhs.details.title < rhs.details.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(details.title)
    }
}
