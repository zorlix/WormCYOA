//
//  Color-Theme.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var itemSelected: Color {
        Color(red: 96 / 255, green: 9 / 255, blue: 130 / 255)
    }
    
    static var subItemBasic: Color {
        Color(red: 66 / 255, green: 66 / 255, blue: 66 / 255)
    }
    
    static var subItemSelected: Color {
        Color(red: 190 / 255, green: 59 / 255, blue: 241 / 255)
    }
}
