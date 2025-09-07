//
//  ShowingImages.swift
//  WormCYOA
//
//  Created by Josef Černý on 07.07.2025.
//

import SwiftUI

@Observable class ShowingImages {
    let key = "showingImages"
    
    var show = true {
        didSet {
            if let encoded = try? JSONEncoder().encode(show) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode(Bool.self, from: data) {
                show = decoded
                return
            }
        }
        
        show = true
    }
}
