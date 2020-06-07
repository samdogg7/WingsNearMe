//
//  SideMenuTableVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import SideMenu

class SideMenuVC: UITableViewController {
    let reusableCellId = "SideMenuCell"
    var delegate: SideMenuNavigationControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
                
        delegate = menu.sideMenuDelegate
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sidemenu-background") ?? UIImage(systemName: "star")
        imageView.backgroundColor = .clear
        self.view.addSubview(imageView)
        imageView.frame = tableView.bounds
        imageView.contentMode = .scaleAspectFit
//        tableView.backgroundView = imageView
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        //FindWingsVC
        case 0:
            guard let vc = storyboard?.instantiateViewController(identifier: "FindWings") as? FindWingsVC else { return }
            if let _delegate = delegate as? UIViewController, vc.restorationIdentifier != _delegate.restorationIdentifier {
                navigationController?.pushViewController(vc, animated: true)
            } else {
                navigationController?.dismiss(animated: true, completion: nil)
            }
        //Social
        case 1:
           break
        //Settings
        case 2:
            guard let vc = storyboard?.instantiateViewController(identifier: "Settings") else { return }
            if let _delegate = delegate as? UIViewController, vc.restorationIdentifier != _delegate.restorationIdentifier {
                navigationController?.pushViewController(vc, animated: false)
            } else {
                navigationController?.dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}
