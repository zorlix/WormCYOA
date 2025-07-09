//
//  GridView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct GridView<Content: View>: View {
    let columns = [ GridItem(.adaptive(minimum: 200), spacing: 20) ]
    let content: () -> Content
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            content()
        }
        .padding(.bottom)
    }
}
