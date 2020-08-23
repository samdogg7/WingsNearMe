//
//  PhotoRequest.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

class PhotoRequest: GoogleRequest {
    var url: URL?
    
    init(photoId: String, testing: Bool) {
        if testing {
            self.url = URL(string: "https://samdoggett.com/WingsNearMe/TestResponses/\(photoId.suffix(5)).jpg")
        } else if let keys = PlistHandler.getPlist(named: .api, fileType: ApiKeysModel.self), let mapKey = keys.mapsKey {
            self.url = URL(string: .placeUrl + "photo?maxwidth=480&photoreference=\(photoId)&key=" + mapKey)
        }
    }
}
