//
//  RestaurantReview.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/26/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

// MARK: - RestaurantReview
class RestaurantReviews: Codable {
    var wingAverages, spiceAverages, sauceAverages, sidesAverages: Averages
    var userReviews: [String:UserReview]

    enum CodingKeys: String, CodingKey {
        case wingAverages = "WingAverages"
        case spiceAverages = "SpiceAverages"
        case sauceAverages = "SauceAverages"
        case sidesAverages = "SidesAverages"
        case userReviews = "UserReviews"
    }

    init() {
        self.wingAverages = Averages(ratingCount: 0, ratingTotal: 0)
        self.spiceAverages = Averages(ratingCount: 0, ratingTotal: 0)
        self.sauceAverages = Averages(ratingCount: 0, ratingTotal: 0)
        self.sidesAverages = Averages(ratingCount: 0, ratingTotal: 0)
        self.userReviews = [String:UserReview]()
    }
    
    // You must decode the JSON manually
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.wingAverages = try container.decode(Averages.self, forKey: .wingAverages)
        self.sauceAverages = try container.decode(Averages.self, forKey: .sauceAverages)
        self.sidesAverages = try container.decode(Averages.self, forKey: .sidesAverages)
        self.spiceAverages = try container.decode(Averages.self, forKey: .spiceAverages)
        
        self.userReviews = [String:UserReview]()
        
        if let userReviewsSubContainer = try? container.nestedContainer(keyedBy: GenericCodingKey.self, forKey: .userReviews) {
            for key in userReviewsSubContainer.allKeys {
                if let userReview = try? userReviewsSubContainer.decode(UserReview.self, forKey: key) {
                    self.userReviews[key.stringValue] = userReview
                }
            }
        }
    }
}

// MARK: - Averages
class Averages: Codable {
    var ratingCount, ratingTotal: Int
    
    init(ratingCount: Int, ratingTotal: Int) {
        self.ratingCount = ratingCount
        self.ratingTotal = ratingTotal
    }
}

// MARK: - UserReview
class UserReview: Codable {
    var wingRating, spiceRating, sauceRating, sidesRating: Int
    var review: String

    init(wingRating: Int = 0, spiceRating: Int = 0, sauceRating: Int = 0, sidesRating: Int = 0, review: String = "") {
        self.wingRating = wingRating
        self.spiceRating = spiceRating
        self.sauceRating = sauceRating
        self.sidesRating = sidesRating
        self.review = review
    }
}
