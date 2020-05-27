//
//  Review.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/26/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

// MARK: - Review
struct Review: Codable {
    var name, rating, review, placeID: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case rating = "Rating"
        case review = "Review"
        case placeID = "PlaceID"
    }
}
