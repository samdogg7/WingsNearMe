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
        if let keys = PlistHandler.getPlist(named: .api, fileType: ApiKeysModel.self), let geocodeKey = keys.geocodeKey {
            self.url = URL(string: .geoCodeUrl + "latlng=\(lat),\(long)&key=" + geocodeKey)
        }
    }
    
    init(address: String) {
        if let keys = PlistHandler.getPlist(named: .api, fileType: ApiKeysModel.self), let geocodeKey = keys.geocodeKey {
            self.url = URL(string: .geoCodeUrl + "address=\(address)&key=" + geocodeKey)
        }
    }
}
