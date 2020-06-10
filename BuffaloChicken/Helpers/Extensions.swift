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

extension CGFloat {
    static var defaultCornerRadius:CGFloat {
        return 15
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func addRoundedCorners(radius: CGFloat = .defaultCornerRadius, corners: UIRectCorner = [ .allCorners ], borderColor: UIColor = UIColor.systemGray, borderWidth: CGFloat = 0) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        
        // Add border
        if borderWidth > 0 {
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskPath.cgPath // Reuse the Bezier path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
        }
    }
    
    func addBorder(color: UIColor = UIColor.systemGray, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
}

extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {

            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height

            var drawingRect: CGRect = self.bounds

            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 22) +
            (self.navigationController?.navigationBar.frame.height ?? 80)
    }
    
    var navBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 80
    }
}
