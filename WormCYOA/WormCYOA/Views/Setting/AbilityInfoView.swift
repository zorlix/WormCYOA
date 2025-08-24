//
//  AbilityInfoView.swift
//  WormCYOA
//
//  Created by Josef Černý on 23.08.2025.
//

import SwiftUI

struct AbilityInfoView: View {
    var body: some View {
        ScrollView {
            Headline(heading: "Abilities Native to Different Universes")
            
            PureText("As this a Worm CYOA, the abilities you gain here (outside of perks and drawbacks) come from a Shard that was 'borrowed' from one of the three Entities mentioned in the Worm universe. More specifically, it is effectively a conglomerate of different Shards borrowed from an Entity, as a singular Shard is unlikely to be able to provide all the different abilities that are offered in this CYOA. This means that technically, you'll have a single Shard that has other Shards attached to it and that channels their powers down to you.\nThis CYOA does not provide abilities native to other universes even if you pick a different setting. And so you might be asking yourself, 'Can I still learn those abilities?'\nThe answer to that is somewhat complicated. Simply traveling to or dropping into a world will not result in you getting any inherent abilities of the natives. You must either reincarnate or Character-Insert there (or in a crossover between Worm and that world) to get them. And even then, you only have as great a chance of getting those powers as the average person who lives there. So, since everyone in Naruto has at least some chakra that they can train and improve, you would also be guaranteed to have that chakra. But in Avatar: The Last Airbender only a small portion of the population can bend the elements; therefore you’d only have a chance to get bending. With Character-Insert, you know exactly what you’re getting, and you can choose a character you know can bend.\nIt might still be possible for you to learn bending on your own. The Awakened perk might present you with opportunities to make that happen. Some Shard powers might also help you integrate the inherent local powers into your own body. For example, Satyrical’s power could theoretically be used to shapeshift into a Kryptonian if you find yourself in DC, or self-biokinesis could help you integrate chakra into your body. The results are of course not guaranteed.\nIf some power exists in a universe that is external to the people living there, then you’d have access to that power no matter how you came to be in this world, or at least the same access as the average person there. For example, if you went to Worm Shardless, you could absolutely still trigger. Or if a magic system relies on controlling that world’s ambient magic rather than the magic wielder’s own internal magic, you could also learn to wield that power. If a permanent power-up is gained through the use of an object or an event (like a ritual), there would likely be nothing stopping you from taking that same power.")
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.top)
        .contentMargins(30, for: .scrollContent)
    }
}
