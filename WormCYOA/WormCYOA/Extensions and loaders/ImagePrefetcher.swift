//
//  ImagePrefetcher.swift
//  WormCYOA
//
//  Created by Josef Černý on 07.07.2025.
//

import SDWebImageSwiftUI
import SwiftUI

final class ImagePrefetcher {
    static let instance = ImagePrefetcher()
    private let prefetcher = SDWebImagePrefetcher()
    private var urls: [URL] {
        var tempArr = [URL]()
        
        let difficulties: [Item] = Bundle.main.decode("difficulty.json")
        let scenarios: [String: [Item]] = Bundle.main.decode("scenarios.json")
        let incarnation: [String: [Item]] = Bundle.main.decode("characters.json")
        let wormCharacter: [String: [Item]] = Bundle.main.decode("worm.json")
        let perks: [Item] = Bundle.main.decode("perks.json")
        let drawbacks: [Item] = Bundle.main.decode("drawbacks.json")
        
        for item in difficulties {
            if let image = item.image, let url = URL(string: image) {
                tempArr.append(url)
            }
        }
        
        for (_,items) in scenarios {
            for item in items {
                if let image = item.image, let url = URL(string: image) {
                    tempArr.append(url)
                }
            }
        }
        
        for (_,items) in incarnation {
            for item in items {
                if let image = item.image, let url = URL(string: image) {
                    tempArr.append(url)
                }
            }
        }
        
        for (_,characters) in wormCharacter {
            for character in characters {
                if let image = character.image, let url = URL(string: image) {
                    tempArr.append(url)
                }
            }
        }
        
        for perk in perks {
            if let image = perk.image, let url = URL(string: image) {
                tempArr.append(url)
            }
        }
        
        for drawback in drawbacks {
            if let image = drawback.image, let url = URL(string: image) {
                tempArr.append(url)
            }
        }
        
        if tempArr.isEmpty {
            print("Failed to find any data in the file in bundle.")
        } else {
            print("Prefetching images...")
        }
        
        return tempArr
    }
    
    private init() { }
    
    func startPrefetching() {
        prefetcher.prefetchURLs(urls)
    }
    
    func stopPrefetching() {
        prefetcher.cancelPrefetching()
    }
}
