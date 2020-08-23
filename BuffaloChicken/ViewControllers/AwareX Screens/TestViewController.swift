//
//  TestViewController.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/29/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var mainStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let checkbox = AWXCheckbox(text: "Test label that should not get compressed", playbackSpeed: 1, animated: true)
        
        mainStack.addArrangedSubview(checkbox)

    }
}
