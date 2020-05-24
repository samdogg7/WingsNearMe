//
//  RestaurantTableViewCell.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/12/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var phone: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var ratingStack: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    
    var restaurant : Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            
            name.text = restaurant.name
            
            updateRating(rating: restaurant.rating)
            
            imgView.layer.cornerRadius = imgView.frame.size.width/2
            imgView.clipsToBounds = true
            
            location.text = restaurant.formattedAddress
            phone.text = restaurant.formattedPhoneNumber
        }
    }
    
    func updateRating(rating: Double) {
        let stars: [UIImageView?] = [
            ratingStack.arrangedSubviews[0] as? UIImageView,
            ratingStack.arrangedSubviews[1] as? UIImageView,
            ratingStack.arrangedSubviews[2] as? UIImageView,
            ratingStack.arrangedSubviews[3] as? UIImageView,
            ratingStack.arrangedSubviews[4] as? UIImageView
        ]
        
        for star in stars {
            star?.image = UIImage(systemName: "star")
        }
        
        let rating_int = Int(rating.rounded(.down))
        let decimal = rating - Double(rating_int)
        
        ratingLabel.text = String(rating)
        
        for i in 0..<rating_int {
            stars[i]?.image = UIImage(systemName: "star.fill")
        }
        
        if decimal >= 0.75 {
            stars[rating_int]?.image = UIImage(systemName: "star.fill")
        } else if decimal >= 0.25 {
            stars[rating_int]?.image = UIImage(systemName: "star.lefthalf.fill")
        }
    }
}
