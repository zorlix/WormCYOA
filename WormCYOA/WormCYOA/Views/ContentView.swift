//
//  StartView.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftData
import SwiftUI

struct StartView: View {
    @Environment(\.modelContext) var modelContext
    @Query var characters: [PlayerCharacter]
    
    @State private var path = NavigationPath()
    @State private var showingImages = ShowingImages()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(characters) { character in
                NavigationLink(value: character) {
                    Text("SP: \(character.sp), CP: \(character.cp)")
                }
            }
            .navigationTitle("Worm CYOA")
            .navigationDestination(for: PlayerCharacter.self) { character in
                CrossroadsView(path: $path, character: character)
            }
            .toolbar {
                Button("Sample") {
                    let testChar = PlayerCharacter(id: UUID(), sp: 0, cp: 0)
                    modelContext.insert(testChar)
                    try? modelContext.save()
                }
                
                Button {
                    showingImages.show.toggle()
                } label: {
                    if showingImages.show {
                        Text("Hide Images")
                    } else {
                        Text("Show Images")
                    }
                }
            }
            .onAppear {
                ImagePrefetcher.instance.startPrefetching()
                UITextField.appearance().clearButtonMode = .whileEditing
            }
        }
        .preferredColorScheme(.dark)
        .environment(showingImages)
    }
}
