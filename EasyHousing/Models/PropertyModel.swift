//
//  PropertyModel.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import Foundation
import SwiftUI

struct Address{
    let street_address: String
    let city: String
    let state: String
    let zipcode: Int
}

struct Features{
    let baths: Int
    let beds: Int
    let hometype: String
    let livingArea: Double
    let isPetFriendly: Bool
    let amenities: [String]?
}

struct PropertyModel {
    let address: Address
    let list_type: String //either rent or sell
    let features: Features
    let photosURL: String
}

//dummy address
let dummy_address = Address(street_address: "329 Comstock Ave", city: "Syracuse", state: "NY", zipcode: 13210)

//dummy features
let dummy_features = Features(baths: 1, beds: 2, hometype: "house", livingArea: 900.0, isPetFriendly: false, amenities: ["Gym", "Pool", "Laundry"])

struct PropertyList {
    static let dummy_list = PropertyModel(address: dummy_address, list_type: "rent", features: dummy_features, photosURL: "photos/url")
}
