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
import ViewAnimator

extension UIColor {
    class var background:UIColor {
        return UIColor(named: "Background") ?? UIColor.white
    }
    
    class var primary:UIColor {
        return UIColor(named: "Primary") ?? UIColor.white
    }
    
    class var secondary:UIColor {
        return UIColor(named: "Secondary") ?? UIColor.white
    }
    
    class var tertiary:UIColor {
        return UIColor(named: "Tertiary") ?? UIColor.white
    }

    class var border:UIColor {
        return UIColor(named: "Border") ?? UIColor.white
    }
 
    class var orange:UIColor {
        return UIColor(named: "Orange") ?? UIColor.orange
    }
}

extension String {
    static var placeUrl: String {
        return "https://maps.googleapis.com/maps/api/place/"
    }
    
    static var geoCodeUrl: String {
        return "https://maps.googleapis.com/maps/api/geocode/json?"
    }
    
    static var isTestingKey: String {
        return "Testing_enabled"
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension Double {
    static var defaultLatitude:Double {
        return 42.613171
    }
    
    static var defaultLongitude:Double {
        return -70.872139
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
    
    @discardableResult func addRoundedCorners(radius: CGFloat = .defaultCornerRadius, corners: UIRectCorner = [ .allCorners ], hasBorder: Bool = false) -> CAShapeLayer? {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        //Add rounded borders
        if hasBorder {
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskPath.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = UIColor.border.cgColor
            borderLayer.lineWidth = 1
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
            //We do not want to add multiple borders if this is called with a view that uses layoutSubviews.
            //Allows that view to handle removing previous border
            return borderLayer
        }
        return nil
    }
    
    func addBorder(color: UIColor = .border, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
    
    func hideAnimated(duration: Double = 0.25) {
        UIView.transition(with: self, duration: duration, options: .curveLinear, animations: {
                            self.layoutIfNeeded()
                            self.center.y += self.bounds.height
                          }, completion: { _ in
                            self.isHidden = true
                            self.center.y -= self.bounds.height
                          })
    }
}

extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat) {
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
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 22) +
            (self.navigationController?.navigationBar.frame.height ?? 80)
    }
    
    var navBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 80
    }
}

extension Encodable {
    var toDictionary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
