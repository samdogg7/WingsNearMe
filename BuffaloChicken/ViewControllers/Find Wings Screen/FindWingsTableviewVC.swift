//
//  FindWingsTableviewVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/13/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import ViewAnimator

protocol FindWingsTableviewDelegate {
    func addCells(cells: [RestaurantAnnotation])
    func animateTableCells(fromDirection: Direction)
    func scrollToCell(indexPath: IndexPath)
    func hideRestaurantDetail(completion: (()-> Void)?)
    func showRestaurantDetail(restaurant: Restaurant)
}

class FindWingsTableviewVC: UIViewController, UITableViewDelegate,  UITableViewDataSource, FindWingsTableviewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var detailView = RestaurantDetailView().loadNib() as! RestaurantDetailView

    var parentDelegate: FindWingsParentDelegate?
    
    private let cellSpacingHeight: CGFloat = 10
    private let cellId = "RestuarantCell"
    
    private var sortedAnnotations:[RestaurantAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tableViewNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    
        detailView.tableViewDelegate = self
        detailView.isHidden = true
        detailView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(detailView)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        detailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 2.5).isActive = true
        detailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        detailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func showRestaurantDetail(restaurant: Restaurant) {
        detailView.restaurant = restaurant
        detailView.isHidden = false
        
        if let topCellIndexPath = self.tableView.indexPathsForVisibleRows?[0] {
            self.tableView.scrollToRow(at: topCellIndexPath, at: .top, animated: true)
        }
        
        detailView.animate(animations: [AnimationType.from(direction: .bottom, offset: self.view.frame.height)], reversed: false, initialAlpha: 1, duration: 0.5)
    }
    
    func hideRestaurantDetail(completion: (()-> Void)?) {
        detailView.hideAnimated()
        
        if let complete = completion {
            complete()
        }
    }
    
    func addCells(cells: [RestaurantAnnotation]) {
        sortedAnnotations?.removeAll()
        sortedAnnotations = cells
        tableView.reloadData()
    }
    
    func scrollToCell(indexPath: IndexPath) {
        if !detailView.isHidden {
            hideRestaurantDetail() {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func animateTableCells(fromDirection: Direction = .bottom) {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            var cells:[RestaurantTableViewCell] = []
            for indexPath in indexPaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
                    cells.append(cell)
                }
            }
            UIView.animate(views: cells, animations: [AnimationType.from(direction: fromDirection, offset: 100.0)], duration: 1.5)
        }
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = sortedAnnotations?[indexPath.section].restaurant
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = restaurant
        
        cell.addRoundedCorners(borderWidth: 1, borderColor: .separator)
        cell.clipsToBounds = true
                
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedAnnotations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let annotation = sortedAnnotations?[indexPath.section] else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        showRestaurantDetail(restaurant: annotation.restaurant)
    }
}
