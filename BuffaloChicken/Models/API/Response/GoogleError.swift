//
//  GoogleError.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/4/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

enum ErrorType {
    case decoding
    case unknown
}

class GoogleError: Error {
    var status: String?
    var errorType: ErrorType?

    init(status: String) {
        self.status = status
    }
    
    init(type: ErrorType) {
        self.errorType = type
    }
}
