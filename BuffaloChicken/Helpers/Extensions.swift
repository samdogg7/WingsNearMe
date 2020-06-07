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
import Lottie
import SideMenu

extension UIColor {
    class var inverse:UIColor {
        return UIColor(named: "InverseSystem") ?? UIColor.systemGray2
    }
}

extension String {
    static var baseUrl: String {
        return "https://maps.googleapis.com/maps/api/place/"
    }

    static var api_key: String {
        return "AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo"
    }
    
    static var testing_enabled: String {
        return "Testing_enabled"
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
        return 12070
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
