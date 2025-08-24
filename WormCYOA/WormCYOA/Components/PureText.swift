//
//  PureText.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct PureText: View {
    let text: String
    
    var body: some View {
        Text(.init(text))
            .multilineTextAlignment(.center)
            .padding(.bottom)
    }
    
    init(_ text: String) {
        self.text = text
    }
}
