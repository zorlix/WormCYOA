//
//  TextfieldView.swift
//  WormCYOA
//
//  Created by Josef Černý on 08.07.2025.
//

import SwiftUI

fileprivate struct TextfieldMod: ViewModifier {
    var numbersOnly: Bool
    
    func body(content: Content) -> some View {
        VStack {
            content
                .keyboardType(numbersOnly ? .numberPad : .default)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white)
                )
        }
        .padding(.bottom)
    }
}

extension View {
    func textfieldStyle(numbersOnly: Bool = false) -> some View {
        modifier(TextfieldMod(numbersOnly: numbersOnly))
    }
}
