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
    var mapFrame: CGRect?
    var detailView = RestaurantDetailView().loadNib() as! RestaurantDetailView
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _restaurant = restaurant, let _mapFrame = mapFrame else { return }
                
        detailView.restaurant = _restaurant
        
        self.view.addSubview(detailView)
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        detailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:_mapFrame.height + self.topbarHeight ).isActive = true
        detailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        detailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)) )
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}
