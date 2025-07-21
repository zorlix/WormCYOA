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
    
    /// Incarnation method
    var incarnationMethod: Item?
    
    /// Character-insert
    var overtakenIdentity: Item?
    
    /// Reincarnation
    var reincarnationType: Item? /// OC, twin, family member
    var twin: Item?
    var familyMember: Item?
    
    var sex: Item?
    var age: Int?
    var appearance: Item?
    var appearanceDesc: String?
    
    var family: Item?
    var extraFamily: [Item] = []
    var homelife: Item?
    var homelifeDesc: String?
    
    var education: Item?
    var job: Item?
    var eduJobHistory: String?
    
    /// Notes
    var characterNotes: String? 
    
    init(id: UUID, sp: Int, cp: Int) {
        self.id = id
        self.sp = sp
        self.cp = cp
    }
    
    // Item structs that have count
    func displayCountedItem(_ item: Item, forArr: [Item]? = nil, forVar: Item? = nil) -> Item {
        if let array = forArr {
            for classItem in array {
                if item.title == classItem.title {
                    return classItem
                }
            }
            
            return item
        }
        
        if let variable = forVar {
            if item.title == variable.title {
                return variable
            } else {
                return item
            }
        }
        
        return item
    }
    
    func isItemSelected(_ item: Item, inVar: Item? = nil, inArr: [Item]? = nil) -> Bool {
        if let variable = inVar {
            if item.title == variable.title {
                return true
            } else {
                return false
            }
        }
        
        if let array = inArr {
            for classItem in array {
                if item.title == classItem.title {
                    return true
                }
            }
            
            return false
        }
        
        return false
    }
    
    // Resolving requirements:
    func isReqMet(of item: Item) -> Bool {
        guard let req = item.requirement else {
            return false // If it doesn't have requirement, just return false - never disable.
        }
        
        if req.starts(with: "Age") {
            let cleaned = req.replacingOccurrences(of: "Age", with: "").trimmingCharacters(in: .whitespaces)
            
            if cleaned.hasSuffix("+") {
                let number = cleaned.dropLast()
                if let minimumAge = Int(number) {
                    if let unwrappedAge = age {
                        if unwrappedAge >= minimumAge {
                            return false
                        }
                    }
                }
            }
            
            if cleaned.contains("-") {
                let parts = cleaned.split(separator: "-").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                if parts.count == 2 {
                    if let unwrappedAge = age {
                        if unwrappedAge >= parts[0] && unwrappedAge <= parts[1] {
                            return false
                        }
                    }
                }
            }
            
            return true
        }
        
        let andSegments = req.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for segment in andSegments {
            let orSegments = segment.components(separatedBy: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            let classContains = orSegments.contains(where: { requirement in
                ownsItem(withTitle: requirement)
            })
            
            if classContains {
                return false
            }
        }
        
//        if let unwrappedArray = array {
//            if unwrappedArray.contains(where: { $0.title == req }) {
//                return false
//            }
//        }
//
//        if let unwrappedVariable = variable {
//            if req == unwrappedVariable.title {
//                return false
//            }
//        }
        
        return true
    }
    
    func ownsItem(withTitle title: String) -> Bool {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let optional = child.value as? Item?, let item = optional {
                if item.title == title {
                    return true
                }
            }
            
            if let array = child.value as? [Item] {
                if array.contains(where: { $0.title == title }) {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Change values in this class.
    /// Assigning to simple variable
    func setValue<T: Equatable>(for classValue: inout T?, from value: T) {
        if classValue == value {
            classValue = nil
        } else {
            classValue = value
        }
    }
    
    /// Assigning to array.
    func setValue<T: Equatable>(for classArray: inout [T], from value: T) {
        if let array = classArray as? [Item], let item = value as? Item {
            if let index = array.firstIndex(of: item) {
                classArray.remove(at: index)
            } else {
                classArray.append(value)
            }
        }
    }
    
    // Increasing counts of selected items
    enum CountOperations { case increase, decrease }
    
    /// Use this if trying to assign to simple variable.
    func changeCount(of item: Item, for variable: inout Item?, action: CountOperations) {
        if let tempVar = variable {
            if item.title == tempVar.title {
                if var count = tempVar.count {
                    switch action {
                    case .increase:
                        count += 1
                        variable?.count = count
                        return
                    case .decrease:
                        count -= 1
                        if count == 0 {
                            variable = nil
                            return
                        }
                        variable?.count = count
                        return
                    }
                }
            }
        }
        
        if action == .increase {
            var tempItem = item
            tempItem.count = 1
            variable = tempItem
        }
    }
    
    /// Use this if trying to assign to an array. 
    func changeCount(of item: Item, in array: inout [Item], action: CountOperations) {
        for classItem in array {
            if item.title == classItem.title {
                if var count = classItem.count, let index = array.firstIndex(of: classItem) {
                    switch action {
                    case .increase:
                        count += 1
                        array[index].count = count
                        return
                    case .decrease:
                        count -= 1
                        if count == 0 {
                            array.remove(at: index)
                            return
                        }
                        array[index].count = count
                        return
                    }
                }
            }
        }
        
        if action == .increase {
            var tempItem = item
            tempItem.count = 1
            array.append(tempItem)
        }
    }
    
    func reset<T>(_ keyPaths: [ReferenceWritableKeyPath<PlayerCharacter, T?>]) {
        for keyPath in keyPaths {
            self[keyPath: keyPath] = nil
        }
    }
}
