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
        self.url = URL(string: .baseUrl + "nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&type=food&keyword=\(_query)&key=" + .api_key)
    }
    
    init() {
        self.url = URL(string: "https://samdoggett.com/WingsNearMe/NearbySearch.json")
    }
}
