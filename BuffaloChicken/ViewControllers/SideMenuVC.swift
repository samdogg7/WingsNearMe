//
//  SideMenuTableVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import SideMenu

@objc public protocol SideMenuVCDelegate {
    @objc func sideMenuPressed()
}

class SideMenuVC: UITableViewController {
    let reusableCellId = "SideMenuCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sidemenu-background") ?? UIImage(systemName: "star")
        imageView.contentMode = .bottom
        tableView.backgroundView = imageView
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //FindWingsVC
        case 0:
            break
        //Social
        case 1:
           break
        //Settings
        case 2:
            break
        default:
            break
        }
    }
}
