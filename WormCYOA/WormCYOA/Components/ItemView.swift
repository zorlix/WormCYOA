//
//  ItemView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    var selected: Bool = false
    var difficulty: Item?
    
    var descriptionFormatted: [String] { item.desc.components(separatedBy: "\n") }
    
    var points: [String: Int] {
        var tempDict = [String: Int]()
        
        let easyDiffs = ["Creator Mode", "God Mode", "Very Easy", "Easy"]
        let hardDiffs = ["Hard", "Very Hard", "Skitter Mode", "Masochist Mode"]
        
        func trueCost(of number: Int) -> Int {
            let halfDouble: Double = Double(number) / 2
            let half: Int = Int(halfDouble.rounded(.up))
            var tempNum = number
            var count = 1
            if let tempCount = item.count {
                count = tempCount
            }
            
            if let difficultyTemp = difficulty {
                if easyDiffs.contains(difficultyTemp.title) {
                    tempNum += half
                } else if hardDiffs.contains(difficultyTemp.title) {
                    tempNum -= half
                }
                
                tempNum *= count
                return tempNum
            } else {
                return tempNum * count
            }
        }
        
        if let spCost = item.SPCost {
            tempDict["spCost"] = trueCost(of: spCost)
        }
        
        if let spGain = item.SPGain {
            tempDict["spGain"] = trueCost(of: spGain)
        }
        
        if let cpCost = item.CPCost {
            tempDict["cpCost"] = trueCost(of: cpCost)
        }
        
        if let cpGain = item.CPGain {
            tempDict["cpGain"] = trueCost(of: cpGain)
        }
        
        return tempDict
    }
    
    @Environment(ShowingImages.self) var showingImages
    
    var increase: () -> Void = { }
    var decrease: () -> Void = { }
    
    var body: some View {
        VStack {
            VStack {
                if showingImages.show {
                    if let image = item.image {
                        ImageLoader(url: image)
                    }
                }
                
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                if let count = item.count {
                    HStack {
                        Button(action: decrease) {
                            Image(systemName: "minus.circle")
                                .font(.title2.bold())
                        }
                        
                        Text("Count: \(count)")
                            .font(.headline)
                            .padding(.bottom, 3)
                            .padding(.horizontal, 5)
                        
                        Button(action: increase) {
                            Image(systemName: "plus.circle")
                                .font(.title2.bold())
                        }
                    }
                }
                
                VStack {
                    if let spCost = points["spCost"] {
                        Text("Cost: \(spCost) SP")
                    }
                    
                    if let cpCost = points["spGain"] {
                        Text("Cost: \(cpCost) CP")
                    }
                    
                    if let spGain = points["cpCost"] {
                        Text("Gain: \(spGain) SP")
                    }
                    
                    if let cpGain = points["cpGain"] {
                        Text("Gain: \(cpGain) CP")
                    }
                    
                    if let incompatibility = item.incompatibility {
                        Text("Incompatibility: \(incompatibility)")
                            .multilineTextAlignment(.center)
                    }
                    
                    if let requirement = item.requirement {
                        Text("Requirement: \(requirement)")
                            .multilineTextAlignment(.center)
                    }
                }
                .font(.caption)
                .padding(.bottom, 10)
            }
            
            if let comment = item.comment {
                Text(comment)
                    .font(.footnote)
                    .italic()
                    .padding(.bottom, 10)
            }
            
            ForEach(descriptionFormatted, id: \.self) { paragraph in
                Text(paragraph)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, descriptionFormatted.last == paragraph ? 0 : 5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.itemSelected.opacity(selected ? 1 : 0))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white)
        )
        .fixedSize(horizontal: false, vertical: true)
//        .contentShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        let showingImage = ShowingImages()
        
        ScrollView {
            Button {
                
            } label: {
                ItemView(item: .example, selected: false, difficulty: Item(title: "Standard", SPCost: 12, desc: "sksk"))
                    .environment(showingImage)
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Character")
        .navigationBarTitleDisplayMode(.inline)
        .contentMargins(20, for: .scrollContent)
    }
    .preferredColorScheme(.dark)
}
