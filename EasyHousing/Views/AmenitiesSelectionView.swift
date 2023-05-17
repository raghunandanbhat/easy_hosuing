//
//  AmenitiesSelectionView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI

struct AmenitiesSelectionView: View {
    @Binding var selectedAmenities: [String]
    var allAmenities: [String]
    var onDone: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(allAmenities, id: \.self) { amenity in
                    MultipleSelectionRow(title: amenity, isSelected: selectedAmenities.contains(amenity)) {
                        if let index = selectedAmenities.firstIndex(of: amenity) {
                            selectedAmenities.remove(at: index)
                        } else {
                            selectedAmenities.append(amenity)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Select all that apply"))
            .navigationBarItems(trailing:
                Button(action: {
                    onDone()
                }) {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(selectedAmenities.isEmpty ? .gray : .blue)
                }
                .disabled(selectedAmenities.isEmpty)
            )
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

