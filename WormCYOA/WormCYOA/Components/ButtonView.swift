//
//  ButtonView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let buttonAction: () -> Void
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.headline)
                .padding(20)
                .background(.itemSelected)
                .clipShape(.rect(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white, lineWidth: 3)
                )
                .padding(.vertical)
        }
        .buttonStyle(.plain)
    }
}
