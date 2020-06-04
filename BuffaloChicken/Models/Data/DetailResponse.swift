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
struct DetailResponse: GoogleResponse, Codable {
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
    var website: String?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case openingHours = "opening_hours"
        case rating, website
    }
}

// MARK: - OpeningHours
struct Hours: Codable {
    var weekdayText: [String]?

    enum CodingKeys: String, CodingKey {
        case weekdayText = "weekday_text"
    }
}
