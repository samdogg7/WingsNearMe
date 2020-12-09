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
    func animateTableCells(fromBottom: Bool)
    func scrollToCell(indexPath: IndexPath)
    func showRestaurantDetail(restaurant: Restaurant)
}

class FindWingsTableviewVC: UIViewController, UITableViewDelegate,  UITableViewDataSource, FindWingsTableviewDelegate {
    private let cellSpacingHeight: CGFloat = 10
    private let cellId = "RestuarantCell"
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        let tableViewNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        table.register(tableViewNib, forCellReuseIdentifier: cellId)
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    var parentDelegate: FindWingsParentDelegate?
    private var sortedAnnotations:[RestaurantAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func showRestaurantDetail(restaurant: Restaurant) {
        let detailViewController = RestaurantDetailViewController(restaurant: restaurant, initialHeight: view.bounds.height)
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = self
        
        if let topCellIndexPath = self.tableView.indexPathsForVisibleRows?[0] {
            self.tableView.scrollToRow(at: topCellIndexPath, at: .top, animated: true)
        }
            
        navigationController?.present(detailViewController, animated: true, completion: nil)
//        self.present(detailViewController, animated: true, completion: nil)
    }
    
    func addCells(cells: [RestaurantAnnotation]) {
        sortedAnnotations?.removeAll()
        sortedAnnotations = cells
        tableView.reloadData()
    }
    
    func scrollToCell(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func animateTableCells(fromBottom: Bool) {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            var cells:[RestaurantTableViewCell] = []
            for indexPath in indexPaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
                    cells.append(cell)
                }
            }
            if fromBottom {
                UIView.animate(views: cells, animations: [AnimationType.from(direction: .bottom, offset: 100.0)], duration: 0.5)
            } else {
                UIView.animate(views: cells, animations: [AnimationType.from(direction: .bottom, offset: 100.0)], duration: 0.5)
            }
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
        cell.addRoundedCorners(hasBorder: true)
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

extension FindWingsTableviewVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let upperAnchor = self.parent?.view.safeAreaLayoutGuide.topAnchor else { return nil }
        return SlidePresentationController(presentedViewController: presented, presenting: presenting, upperAnchor: upperAnchor, middleAnchor: self.view.topAnchor)
    }
}
