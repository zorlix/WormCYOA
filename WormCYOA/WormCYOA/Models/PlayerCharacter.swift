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
    
    // Perks
    var perks: [Item] = []
    
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
    
    // All values to check for methods below
    private static let itemsToCheck: [ReferenceWritableKeyPath<PlayerCharacter, Item?>] = [
        \.metaTarget, \.metaAwareness, \.metaOther, \.difficulty, \.setting, \.altWorld, \.crossover, \.location, \.scenario, \.timeShift, \.gender, \.incarnationMethod, \.overtakenIdentity, \.reincarnationType, \.twin, \.familyMember, \.sex, \.appearance, \.family, \.homelife, \.education, \.job
    ]
    
    private static let arraysToCheck: [ReferenceWritableKeyPath<PlayerCharacter, [Item]>] = [
        \.extraFamily, \.perks
    ]
    
    // Resolving requirements:
    func isReqMet(of item: Item) -> Bool {
        guard let req = item.requirement else {
            return false // If it doesn't have requirement, just return false - never disable.
        }
        
        let andSegments = req.split(separator: ";")
        
        for segment in andSegments {
            let orSegments = segment.split(separator: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            let classContains = orSegments.contains(where: { requirement in
                if requirement.starts(with: "Age ") {
                    return verifyAge(from: requirement)
                } else {
                    return ownsItem(withTitle: requirement)
                }
            })
            
            if !classContains {
                return true
            }
        }
        
        return false
    }
    
    private func ownsItem(withTitle title: String) -> Bool {
        for keypath in Self.itemsToCheck {
            let optionalItem = self[keyPath: keypath]
            
            if let item = optionalItem {
                if item.title == title {
                    return true
                }
            }
        }
        
        for keypath in Self.arraysToCheck {
            let itemArray = self[keyPath: keypath]
            
            if itemArray.contains(where: { $0.title == title }) {
                return true
            }
        }
        
        return false
    }
    
    private func verifyAge(from req: String) -> Bool {
        guard req.starts(with: "Age ") else { return false }
        
        let cleaned = req.replacingOccurrences(of: "Age", with: "").trimmingCharacters(in: .whitespaces)
        
        if cleaned.hasSuffix("+") {
            let number = cleaned.dropLast()
            if let minimumAge = Int(number), let unwrappedAge = age {
                if unwrappedAge >= minimumAge {
                    return true
                }
            }
        }
        
        if cleaned.contains("-") {
            let parts = cleaned.split(separator: "-").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            if parts.count == 2, let unwrappedAge = age {
                if unwrappedAge >= parts[0] && unwrappedAge <= parts[1] {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Resolving incompatibilities:
    func isCompatible(_ item: Item) -> Bool {
        guard let incompatibility = item.incompatibility else { return false }
        
        let incompatibilities = incompatibility.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for keypath in Self.itemsToCheck {
            if let classItem = self[keyPath: keypath] {
                if incompatibilities.contains(classItem.title) {
                    return true
                }
            }
        }
        
        for keypath in Self.arraysToCheck {
            let array = self[keyPath: keypath]
            for classItem in array {
                if incompatibilities.contains(classItem.title) {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Change values in this class.
    var deletedItems: [Item] = []
    
    /// Assigning to simple variable
    func setValue(for classItem: inout Item?, from value: Item) {
        if classItem == value {
            classItem = nil
            deletedItems.append(value)
        } else {
            classItem = value
        }
    }
    
    /// Assigning to array.
    func setValue(for classArray: inout [Item], from value: Item) {
        if classArray.contains(value) {
            classArray.removeAll(where: { $0 == value })
            deletedItems.append(value)
        } else {
            classArray.append(value)
        }
        
    }
    
    /// Confirming requirements
    func validateRequirements() {
        guard deletedItems.isEmpty == false else { return }
        
        print("Validating...")
        
        for item in deletedItems {
            for keypath in Self.itemsToCheck {
                if let classItem = self[keyPath: keypath], let req = classItem.requirement {
                    if req.contains(item.title) {
                        if req.contains(" or ") {
                            let andSegments = req.split(separator: ";")
                            
                            for segment in andSegments {
                                var orSegments = segment.split(separator: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
                                
                                if orSegments.contains(item.title) && orSegments.count == 1 {
                                    self[keyPath: keypath] = nil
                                }
                                
                                if orSegments.contains(item.title) {
                                    if let index = orSegments.firstIndex(of: item.title) {
                                        orSegments.remove(at: index)
                                        
                                        var reqFulfilled = false
                                        for orSegment in orSegments {
                                            if ownsItem(withTitle: orSegment) {
                                                reqFulfilled = true
                                            }
                                        }
                                        if !reqFulfilled {
                                            self[keyPath: keypath] = nil
                                        }
                                    }
                                }
                            }
                        } else {
                            self[keyPath: keypath] = nil
                        }
                    }
                }
            }
            
            for keypath in Self.arraysToCheck {
                for classItem in self[keyPath: keypath] {
                    if let req = classItem.requirement {
                        if req.contains(item.title) {
                            if req.contains(" or ") {
                                let andSegments = req.split(separator: ";")
                                
                                for segment in andSegments {
                                    var orSegments = segment.split(separator: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
                                    
                                    if orSegments.contains(item.title) && orSegments.count == 1 {
                                        if let index = self[keyPath: keypath].firstIndex(of: classItem) {
                                            self[keyPath: keypath].remove(at: index)
                                        }
                                    }
                                    
                                    if orSegments.contains(item.title) {
                                        if let orIndex = orSegments.firstIndex(of: item.title) {
                                            orSegments.remove(at: orIndex)
                                            
                                            var reqFulfilled = false
                                            for orSegment in orSegments {
                                                if ownsItem(withTitle: orSegment) {
                                                    reqFulfilled = true
                                                }
                                            }
                                            if !reqFulfilled {
                                                if let index = self[keyPath: keypath].firstIndex(of: classItem) {
                                                    self[keyPath: keypath].remove(at: index)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                if let index = self[keyPath: keypath].firstIndex(of: classItem) {
                                    self[keyPath: keypath].remove(at: index)
                                }
                            }
                        }
                    }
                }
            }
            
            if let index = deletedItems.firstIndex(of: item) {
                deletedItems.remove(at: index)
            }
        }
    }
    
    func validateAgeReq() {
        for keypath in Self.itemsToCheck {
            if let classItem = self[keyPath: keypath], let req = classItem.requirement {
                if req.contains("Age ") {
                    let andSegments = req.split(separator: ";")
                    
                    for segment in andSegments {
                        var orSegments = segment.split(separator: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
                        
                        let fulfilled = orSegments.contains(where: { requirement in
                            if requirement.starts(with: "Age ") {
                                return verifyAge(from: requirement)
                            } else {
                                return true
                            }
                        })
                        
                        if !fulfilled {
                            self[keyPath: keypath] = nil
                        }
                    }
                }
            }
        }
        
        for keypath in Self.arraysToCheck {
            for classItem in self[keyPath: keypath] {
                if let req = classItem.requirement {
                    if req.contains("Age ") {
                        let andSegments = req.split(separator: ";")
                        
                        for segment in andSegments {
                            var orSegments = segment.split(separator: " or ").map { $0.trimmingCharacters(in: .whitespaces) }
                            
                            let fulfilled = orSegments.contains(where: { requirement in
                                if requirement.starts(with: "Age ") {
                                    return verifyAge(from: requirement)
                                } else {
                                    return true
                                }
                            })
                            
                            if !fulfilled {
                                if let index = self[keyPath: keypath].firstIndex(of: classItem) {
                                    self[keyPath: keypath].remove(at: index)
                                }
                            }
                        }
                    }
                }
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
                            let tempVar = variable
                            variable = nil
                            deletedItems.append(tempVar!)
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
                            let itemToCheck = array[index]
                            array.remove(at: index)
                            deletedItems.append(itemToCheck)
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
        var tempArray = [Item]()
        
        for keyPath in keyPaths {
            if let opt = self[keyPath: keyPath] as? Item?, let item = opt {
                tempArray.append(item)
            }
            
            if let array = self[keyPath: keyPath] as? [Item] {
                for item in array {
                    tempArray.append(item)
                }
            }
            
            self[keyPath: keyPath] = nil
        }
        
        deletedItems.append(contentsOf: tempArray)
    }
}
