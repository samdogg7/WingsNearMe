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

extension UIColor {
    class var inverse:UIColor {
        return UIColor(named: "InverseSystem") ?? UIColor.systemGray2
    }
}

extension String {
    static var api_key: String {
        return "AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo"
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

extension UIViewController {
    func presentLoadingAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Loading tenders...", message: "", preferredStyle: .alert)
        let animation = AnimationView(animation: Animation.named("loading-tenders"))
        animation.loopMode = .loop
        animation.play()
        
        alertController.view.addSubview(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        animation.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        animation.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 100).isActive = true

        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
