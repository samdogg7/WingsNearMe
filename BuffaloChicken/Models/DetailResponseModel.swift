//
//  DetailResponse.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/12/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
//

import Foundation

// MARK: - DetailsResponse
struct DetailResponse: Codable {
    var htmlAttributions: [JSONAny]?
    var result: PlaceDetail?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case result, status
    }
}

// MARK: - Result
struct PlaceDetail: Codable {
    var formattedAddress, formattedPhoneNumber: String?
    var openingHours: Hours?
    var rating: Double?
    var reviews: [Review]?
    var website: String?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case openingHours = "opening_hours"
        case rating, reviews, website
    }
}

// MARK: - OpeningHours
struct Hours: Codable {
    var weekdayText: [String]?

    enum CodingKeys: String, CodingKey {
        case weekdayText = "weekday_text"
    }
}

// MARK: - Review
struct Review: Codable {
    var authorName: String?
    var authorURL: String?
    var language: String?
    var profilePhotoURL: String?
    var rating: Int?
    var relativeTimeDescription, text: String?
    var time: Int?

    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time
    }
}
