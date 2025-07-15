//
//  EduJobHistoryView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct EduJobHistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    @FocusState.Binding var focused: Bool 
    
    var body: some View {
        MinorHeadline(text: "Education and Job History")
        PureText("Here you may specify (if you wish to) exactly what school you were (or still are) studying, what skills you learnt there, what job you now or are trying to get.\nNote that whatever you write in here will only be taken into account if it does not contradict your choices above.")
        
        let history = Binding<String>(
            get: { character.eduJobHistory ?? "" },
            set: { newValue in
                character.eduJobHistory = newValue.isEmpty ? nil : newValue
            }
        )
        TextField("Details", text: history)
            .textfieldStyle()
            .focused($focused)
    }
}
