//
//  GeocodeResponse.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

// MARK: - GeocodeResponse
@objcMembers class GeocodeResponse: NSObject, Codable, GoogleResponse {
    var error_message: String?
    var status: String?
    var htmlAttributions: [JSONAny]?
    var results: [AddressResult]?

    init(results: [AddressResult]?) {
        self.results = results
    }
}

// MARK: - Result
@objcMembers class AddressResult: NSObject, Codable {
    var addressComponents: [AddressComponent]?
    var formattedAddress: String?
    var geometry: Geometry?
    var placeID: String?
    var types: [String]?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case types
    }

    init(addressComponents: [AddressComponent]?, formattedAddress: String?, geometry: Geometry?, placeID: String?, types: [String]?) {
        self.addressComponents = addressComponents
        self.formattedAddress = formattedAddress
        self.geometry = geometry
        self.placeID = placeID
        self.types = types
    }
}

// MARK: - AddressComponent
@objcMembers class AddressComponent: NSObject, Codable {
    var longName, shortName: String?
    var types: [String]?

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }

    init(longName: String?, shortName: String?, types: [String]?) {
        self.longName = longName
        self.shortName = shortName
        self.types = types
    }
}

// MARK: - Geometry
@objcMembers class Geometry: NSObject, Codable {
    var location: Location?
    var locationType: String?
    var viewport: Viewport?

    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport
    }

    init(location: Location?, locationType: String?, viewport: Viewport?) {
        self.location = location
        self.locationType = locationType
        self.viewport = viewport
    }
}

// MARK: - Location
@objcMembers class Location: NSObject, Codable {
    var lat, lng: Double?

    init(lat: Double?, lng: Double?) {
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Viewport
@objcMembers class Viewport: NSObject, Codable {
    var northeast, southwest: Location?

    init(northeast: Location?, southwest: Location?) {
        self.northeast = northeast
        self.southwest = southwest
    }
}
