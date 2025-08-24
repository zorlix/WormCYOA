//
//  LoreView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.07.2025.
//

import SwiftUI

struct LoreView: View {
    var body: some View {
        ScrollView {
            Headline(heading: "Lore")
            
            PureText("Two Entities spiral through space, past stars and planets alike. Their very bodies shift between dimensions. Approaching a world, one you recognize as Earth, they shatter into millions upon millions of pieces and descend upon millions of Earths. The shattered pieces, Shards of the Entities, take root on empty Earths before bonding with humans. Humans, at their lowest, would go on to learn through conflict. Through this, they would advance the Entity.")
            
            PureText("Only this time, something went wrong with their cycle. A mistake caused the more intelligent of the Entities to crash into a planet where it was, not long after, put down. The Entity's shards remain, in the hands of those who wish the death of the other Entity, but things are not so easy. Even with all the parahumans, those bonded with the Entities' Shards, working in perfect unison, humanity would stand no chance against the remaining Entity in a fight.")
            
            PureText("However, you may change that. You had the luck to be born in a world with an unrestricted Precog who didn't know he was one. One John C. McCrae aka Wildbow. Unfortunately, your whole universe is a blind spot for all Thinkers sans the Entity itself. Wildbow's predictions, while perfect, do not account for your shared universe's existence. Your shared universe is many years ahead of Earth Aleph and Bet, where it is 2011 still. Or perhaps you shall choose to arrive at a different point in time?")
            
            PureText("Soon enough, you might get the chance to experience the wider multiverse yourself. Carefully consider the following and decide just how equipped you'll be when this happens!")
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(30, for: .scrollContent)
    }
}
