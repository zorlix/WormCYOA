//
//  PlayerCharacter.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftData
import SwiftUI

@Model class PlayerCharacter {
    var id: UUID
    var sp: Int
    var cp: Int
    
    // Meta
    var metaTarget: Item?
    var metaAwareness: Item?
    var metaOther: Item?
    
    // Difficulty
    var difficulty: Item?
    
    // Setting
    var setting: Item?
    var altWorld: Item?
    var crossover: Item?
    var location: Item?
    var auElements: Bool = false
    var auDesc: String?
    
    // Scenario
    var scenario: Item?
    var timeShift: Item?
    
    // Character
    /// Basic info
    var name: String?
    var nickName: String?
    var capeName: String?
    var gender: Item?
    var characterInfo: String?
    
    /// Incarnation method
    var incarnationMethod: Item? 
    
    init(id: UUID, sp: Int, cp: Int) {
        self.id = id
        self.sp = sp
        self.cp = cp
    }
    
    func setValue<T: Equatable>(for classValue: inout T?, from value: T) {
        if classValue == value {
            classValue = nil
        } else {
            classValue = value
        }
    }
    
    func resolveCount(of classItem: Item, action: CountOperations) -> Item? {
        var tempItem = classItem
        var count = 1
        if let tempCount = tempItem.count {
            count = tempCount
        }
        
        if action == .increase {
            count += 1
        } else {
            count -= 1
        }
        
        if count == 0 {
            return nil
        } else {
            tempItem.count = count
            return tempItem
        }
    }
    
    func reset<T>(_ keyPaths: [ReferenceWritableKeyPath<PlayerCharacter, T?>]) {
        for keyPath in keyPaths {
            self[keyPath: keyPath] = nil
        }
    }
}
