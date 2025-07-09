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
        
        guard let url = Bundle.main.url(forResource: "imageURLs.json", withExtension: nil) else {
            print("Failed to locate the file from bundle.")
            return tempArr
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to extract data from the file in bundle.")
            return tempArr
        }
        
        guard let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
            print("Failed to decode urls from file in bundle.")
            return tempArr
        }
        
        for (_,urlStr) in decoded {
            if let url = URL(string: urlStr) {
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
