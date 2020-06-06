//
//  PhotoResponse.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit.UIImage

class PhotoResponse: UIImage, GoogleResponse {
    var status: String?
    var htmlAttributions: [JSONAny]?
}
