//
//  Restaurant.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/23/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import CoreLocation
import UIKit.UIImage

class Restaurant: NSObject {
    var name: String
    var isOpen: Bool = false
    var isOpenString: String
    var hoursString: String
    var coordinate: CLLocationCoordinate2D
    var formattedAddress: String
    var formattedPhoneNumber: String
    var rating: Double
    var placeID: String
    var photos: [UIImage]
    
    init(place: Place) {
        self.name = place.name ?? "Restaurant Name"
        if let isOpen = place.openingHours?.openNow {
            self.isOpen = isOpen
            self.isOpenString =  (isOpen ? "Open" : "Closed")
        } else {
            self.isOpenString = "Hours not available"
        }
        self.hoursString = self.isOpenString
        photos = [ UIImage(named: "PlaceholderWing")!, UIImage(named: "PlaceholderWing1")!, UIImage(named: "PlaceholderWing2")!, UIImage(named: "PlaceholderWing3")! ]
        self.coordinate = CLLocationCoordinate2D(latitude: place.geometry?.location?.lat ?? 37.3230, longitude: place.geometry?.location?.lng ?? -122.0322)
        self.formattedAddress = "No formatted address given"
        self.formattedPhoneNumber = "No phone number given"
        self.rating = place.rating ?? 0.0
        self.placeID = place.placeID ?? "PlaceID"
    }
    
    func addDetails(details: PlaceDetail) {
        self.hoursString = formatHours(hours: details.openingHours?.weekdayText)
        
        self.formattedAddress = details.formattedAddress ?? self.formattedAddress
        self.formattedPhoneNumber = details.formattedPhoneNumber ?? self.formattedPhoneNumber
    }
    
    func formatHours(hours: [String]?) -> String {
        
        var str = "Monday: 11:00 AM - 9:00 PM"

        if let days = hours {
            for day in days {
                var _day = day
                if let subString = day.range(of: "Monday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Tuesday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Wendseday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Thursday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Friday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Saturday") {
                    _day.removeSubrange(subString)
                } else if let subString = day.range(of: "Sunday") {
                    _day.removeSubrange(subString)
                }
                
                
            }
        }
        return str
    }
    
    func addPhoto(photo: UIImage, atIndex: Int? = nil) {
        if let index = atIndex {
            self.photos.insert(photo, at: index)
        } else {
            self.photos.append(photo)
        }
    }
}
