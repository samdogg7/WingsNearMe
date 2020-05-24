//
//  RestaurantDetailVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/23/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class RestauarantDetailVC: UIViewController {
    var restaurant: Restaurant?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurant = restaurant {
            name.text = restaurant.name
            hours.text = restaurant.hoursString
            self.location.text = "Location: " + restaurant.formattedAddress
        }
    }
}
