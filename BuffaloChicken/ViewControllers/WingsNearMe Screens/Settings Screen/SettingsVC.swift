//
//  SettingsVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/1/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import SideMenu

class SettingsVC: UITableViewController, SideMenuNavigationControllerDelegate {
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    @IBOutlet weak var testingSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testingSwitch.addTarget(self, action: #selector(testingSwitchFlipped(_:)), for: .touchUpInside)
        testingSwitch.isOn = UserDefaults.standard.bool(forKey: .isTestingKey)
    }
    
    @objc func testingSwitchFlipped(_ sender: UISwitch) {
        UserDefaults.standard.set(testingSwitch.isOn, forKey: .isTestingKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sideMenuNavigationController = segue.destination as? SideMenuNavigationController {
            sideMenuNavigationController.sideMenuDelegate = self
        }
    }
}
