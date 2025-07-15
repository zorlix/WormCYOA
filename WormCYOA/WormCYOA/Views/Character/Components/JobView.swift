//
//  JobView.swift
//  WormCYOA
//
//  Created by Josef Černý on 14.07.2025.
//

import SwiftData
import SwiftUI

struct JobView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var character: PlayerCharacter
    
    let jobs: [Item]
    
    var body: some View {
        Headline(heading: "Job", subheading: "What will your occupation be as a civilian\nYou may choose virtually any profession you can think of, provided you have the education for it (see section above). Upon awakening you will find that you'll already have the job, and you'll have all the knowledge and skills required for it. It will integrate very seamlessly into your life story in that world.\nWarning: Please be reasonable. While you may pick virtually any occupation, it has to actually be possible for you to have that job. The more bizarre and outlandish profession you choose, the less likely it is to work out exactly as you probably intend it to.\nFor example, if you choose to reincarnate as an 18-year-old, and you decide you want to be a medical doctor, you'll likely find yourself disappointed. At best you might be a new applicant to medschool or something similar.\nThese choices are meant to primarily affect you rather than the world at large. So, if whatever you pick would result in too many changes, your choice will be scaled back in some way to avoid this issue.\nIf you choose to be the Queen of England or the president of the United States, your choice is very likely to largely go ignored.\nYou can also decide to not choose anything particular right now and leave this up to chance. If you do so, your job will be chosen for you, in which case it'll likely be something you'll find fulfilling and maybe even enjoyable.")
        
        GridView {
            ForEach(jobs, id: \.title) { job in
                Button {
                    character.setValue(for: &character.job, from: job)
                    try? modelContext.save()
                } label: {
                    ItemView(item: job, selected: character.job == job)
                }
                .buttonStyle(.plain)
                .disabled(character.isReqMet(of: job))
            }
        }
    }
}
