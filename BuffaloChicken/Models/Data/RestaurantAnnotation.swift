//
//  RestaurantAnnotation.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/20/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import MapKit
import CoreLocation

class RestaurantAnnotation: NSObject, MKAnnotation {
    var id: Int
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var restaurant: Restaurant
    var distance: Double
    
    init(id: Int, restaurant: Restaurant, userLocation: CLLocation) {
        self.id = id
        self.restaurant = restaurant
        self.title = restaurant.name
        self.subtitle = restaurant.isOpenString
        self.coordinate = restaurant.coordinate
        self.distance = userLocation.distance(from: CLLocation(latitude: restaurant.coordinate.latitude, longitude: restaurant.coordinate.longitude))
        
        super.init()
    }
}
