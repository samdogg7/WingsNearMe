//
//  SocialVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class SocialVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSubviews()
        
    }
    
    func updateSubviews() {
        label.text = "Social yhickens"
        image.image = UIImage(systemName: "person.circle")
    }
}

