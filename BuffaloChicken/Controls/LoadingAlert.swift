//
//  LoadingAlert.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/6/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

class LoadingAlert: UIAlertController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animation = AnimationView(animation: Animation.named("loading-tenders"))
        animation.loopMode = .loop
        animation.play()
        
        self.view.addSubview(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        animation.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        animation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 100).isActive = true

        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}
