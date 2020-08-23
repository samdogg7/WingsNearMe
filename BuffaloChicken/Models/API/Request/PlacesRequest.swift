//
//  PlacesRequest.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

class PlacesRequest: GoogleRequest {
    var url: URL?
    
    init(query: String, lat: Double, long: Double, radius: Double) {
        let _query = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        if let keys = PlistHandler.getPlist(named: .api, fileType: ApiKeysModel.self), let mapKey = keys.mapsKey {
            self.url = URL(string: .placeUrl + "nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&type=food&keyword=\(_query)&key=" + mapKey)
        }
    }
    
    init() {
        self.url = URL(string: "https://samdoggett.com/WingsNearMe/NearbySearch.json")
    }
}
