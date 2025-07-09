//
//  MinorHeadlineView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct MinorHeadline: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 10)
    }
}
