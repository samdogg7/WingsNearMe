//
//  SettingsVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/1/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import SideMenu

class SettingsVC: UITableViewController, SideMenuVCDelegate {
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuButton.target = self
        sideMenuButton.action = #selector(sideMenuPressed)
    }
    
    @objc func sideMenuPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
