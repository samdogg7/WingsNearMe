//
//  LocationRequest.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

class GeocodeRequest: GoogleRequest {
    var url: URL?
    
    init(lat: Double, long: Double) {
        self.url = URL(string: .geoCodeUrl + "\(lat),\(long)&key=" + .geoCode_api_key)
    }
}
