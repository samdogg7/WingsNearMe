//
//  Extensions.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/28/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation

extension UIColor {
    class var inverse:UIColor {
        return UIColor(named: "InverseSystem") ?? UIColor.systemGray2
    }
}

extension Double {
    static var defaultLatitude:Double {
        return 37.3230
    }
    
    static var defaultLongitude:Double {
        return -122.0322
    }
    
    static var defaultRadius:Double {
        return 10000
    }
}
