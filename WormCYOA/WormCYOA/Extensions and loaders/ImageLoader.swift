//
//  ImageLoader.swift
//  WormCYOA
//
//  Created by Josef Černý on 07.07.2025.
//

import SDWebImageSwiftUI
import SwiftUI

fileprivate struct SDWebImageLoader: View {
    let url: String
    var conentMode: ContentMode = .fit
    
    var body: some View {
//        WebImage(url: URL(string: url)) { image in
//            image
//                .resizable()
//                .aspectRatio(contentMode: conentMode)
//        } placeholder: {
//            Color.gray.opacity(0.3)
//                .frame(width: 200, height: 200)
//                .overlay(
//                    ProgressView()
//                )
//            
//        }
        
        WebImage(url: URL(string: url))
            .resizable()
            .aspectRatio(contentMode: conentMode)
    }
}

struct ImageLoader: View {
    let url: String
    var conentMode: ContentMode = .fit
    
    var body: some View {
        SDWebImageLoader(url: url, conentMode: conentMode)
    }
}
