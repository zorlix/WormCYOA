//
//  PowerFilterView.swift
//  WormCYOA
//
//  Created by Josef Černý on 06.09.2025.
//

import SwiftUI

struct PowerFilterView: View {
    let powerCategory: PowerCategory
    
    @Binding var filterClassifications: [PowerClassification]
    @Binding var filterTiers: [Int]
    @Binding var exactMatch: Bool
    
    var body: some View {
        if powerCategory != .fusion || powerCategory != .universal {
            Menu("Filter options", systemImage: "line.3.horizontal.decrease.circle") {
                Section("Select Classifications") {
                    Button {
                        filterClassifications = PowerClassification.allCases
                    } label: {
                        Text("Select All")
                    }
                    
                    Button {
                        filterClassifications = []
                    } label: {
                        Text("Select None")
                    }
                    
                    Divider()
                    
                    ForEach(PowerClassification.allCases, id: \.self) { classification in
                        Toggle(isOn: isSelectedBinding(for: classification)) {
                            Text(classification.rawValue)
                        }
                    }
                    
                    Divider()
                    
                    Toggle("Exact Match", isOn: $exactMatch)
                }
                
                if powerCategory == .upgrade {
                    Divider()
                    
                    Section("Select Tiers") {
                        Toggle(isOn: isSelectedBinding(for: -1)) {
                            Text("Power Copy")
                        }
                        
                        ForEach(0...3, id: \.self) { index in
                            Toggle(isOn: isSelectedBinding(for: index)) {
                                Text("Tier \(index)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func isSelectedBinding(for classification: PowerClassification) -> Binding<Bool> {
        Binding(
            get: { filterClassifications.contains(classification) },
            set: { isSelected in
                if isSelected {
                    filterClassifications.append(classification)
                } else {
                    filterClassifications.removeAll(where: { $0 == classification })
                }
            }
        )
    }
    
    private func isSelectedBinding(for tier: Int) -> Binding<Bool> {
        Binding(
            get: { filterTiers.contains(tier) },
            set: { isSelected in
                if isSelected {
                    filterTiers.append(tier)
                } else {
                    filterTiers.removeAll(where: { $0 == tier })
                }
            }
        )
    }
}
