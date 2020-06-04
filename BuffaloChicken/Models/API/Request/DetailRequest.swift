//
//  DetailRequest.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

class DetailRequest: GoogleRequest {
    var url: URL?
    
    init(placeId: String, testing: Bool) {
        if testing {
            self.url = URL(string: "https://samdoggett.com/WingsNearMe/TestResponses/\(placeId).json")
        } else {
            self.url = URL(string: .baseUrl + "details/json?place_id=\(placeId)&fields=formatted_address,formatted_phone_number,opening_hours/weekday_text,website&key=" + .api_key)
        }
    }
}
