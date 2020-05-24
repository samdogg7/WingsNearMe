//
//  RestaurantAnnotation.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/20/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    var id: Int
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var restaurant: Restaurant

    init(id: Int, restaurant: Restaurant) {
        self.id = id
        self.restaurant = restaurant
        self.title = restaurant.name
        self.subtitle = restaurant.isOpen
        self.coordinate = restaurant.coordinate
        super.init()
    }
}
