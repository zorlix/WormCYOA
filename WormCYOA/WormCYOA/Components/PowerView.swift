//
//  PowerView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.09.2025.
//

import SwiftUI

struct PowerView: View {
    let power: Power
    
    var selected: Bool = false
    var subItems: [SubItem]? = nil
    var difficulty: Item?
    
    var classifications: String {
        var tempString = ""
        
        for classification in power.classifications {
            tempString.append(classification.rawValue)
            tempString.append("/")
        }
        
        if tempString.last == "/" {
            tempString.removeLast()
        }
        
        return tempString
    }
    
    var body: some View {
        VStack {
            Text(classifications)
                .foregroundStyle(.white)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, -4)
            
            ItemView(
                item: power.details,
                selected: selected,
                subItems: subItems,
                difficulty: difficulty,
                overlayWidth: 0
            )
        }
        .frame(maxWidth: .infinity)
        .background(.titleColorStyle)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.titleColorStyle, lineWidth: 5)
        )
        .clipShape(.rect(cornerRadius: 10))
    }
}
