//
//  Restaurant.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/23/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import CoreLocation

class Restaurant {
    var name: String
    var isOpen: String
    var coordinate: CLLocationCoordinate2D
    var formattedAddress: String
    var formattedPhoneNumber: String
    var rating: Double
    
    init(place: Place) {
        self.name = place.name ?? "Restaurant Name"
        if let isOpen = place.openingHours?.openNow {
            self.isOpen =  (isOpen ? "Open" : "Closed")
        } else {
            self.isOpen = "Hours not available"
        }
        self.coordinate = CLLocationCoordinate2D(latitude: place.geometry?.location?.lat ?? 37.3230, longitude: place.geometry?.location?.lng ?? -122.0322)
        self.formattedAddress = place.placeDetail?.formattedAddress ?? "No formatted address given"
        self.rating = place.rating ?? 0.0
        self.formattedPhoneNumber = place.placeDetail?.formattedPhoneNumber ?? "No phone number given"
    }
}
