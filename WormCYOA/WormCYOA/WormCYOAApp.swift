//
//  WormCYOAApp.swift
//  WormCYOA
//
//  Created by Josef Černý on 05.07.2025.
//

import SwiftData
import SwiftUI

@main
struct WormCYOAApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
        }
        .modelContainer(for: PlayerCharacter.self, isAutosaveEnabled: false)
    }
}
