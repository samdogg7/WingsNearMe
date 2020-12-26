//
//  GenericCodingKey.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 12/14/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

@objcMembers public class GenericCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    required public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    required public init?(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }
}
