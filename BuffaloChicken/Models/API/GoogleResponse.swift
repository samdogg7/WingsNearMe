//
//  GoogleResponse.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

public protocol GoogleResponse: Decodable {
    var status: String? { get set }
    var htmlAttributions: [JSONAny]? { get set }
}
