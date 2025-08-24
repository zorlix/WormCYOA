//
//  HeadlineView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct Headline: View {
    let heading: String
    let subheading: String?
    
    var subheadingFormatted: [String]? {
        return subheading?.components(separatedBy: "\n")
    }
    
    var body: some View {
        VStack {
            Text(heading)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            if let subheading = subheadingFormatted {
                ForEach(subheading, id: \.self) { line in
                    Text(.init(line))
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, line == subheading.last ? 0 : 5)
                }
            }
        }
        .padding(.bottom, 12)
    }
    
    init(heading: String, subheading: String? = nil) {
        self.heading = heading
        self.subheading = subheading
    }
}
