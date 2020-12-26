//
//  FindWingsMapVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/13/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import MapKit

protocol FindWingsMapDelegate {
    func addAnnotations(annotations: [RestaurantAnnotation])
    func selectAnnotation(annotation: RestaurantAnnotation)
    func zoomToRegion(region: MKCoordinateRegion, animated: Bool)
}

class FindWingsMapVC: UIViewController, MKMapViewDelegate, FindWingsMapDelegate {
    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.layer.masksToBounds = true
        map.layer.cornerRadius = .defaultCornerRadius
        map.backgroundColor = .clear
        map.addBorder(color: .border, width: 1)
        return map
    }()
    
    var parentDelegate: FindWingsParentDelegate?
    var tableViewDelegate: FindWingsTableviewDelegate? {
        didSet {
            activeCallout.delegate = tableViewDelegate
        }
    }
    
    private lazy var activeCallout: MapCustomCallout = {
        let callout = MapCustomCallout()
        callout.translatesAutoresizingMaskIntoConstraints = false
        return callout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.view.addSubview(map)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func openRestaurantDetailVC(_ sender: AnnotationButton) {
        if let restaurant = sender.annotation?.restaurant {
            tableViewDelegate?.showRestaurantDetail(restaurant: restaurant)
        }
    }
    
    //MARK: - FindWingsMapDelegate Methods
    
    func addAnnotations(annotations: [RestaurantAnnotation]) {
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
        map.showAnnotations(map.annotations, animated: true)
    }
    
    func selectAnnotation(annotation: RestaurantAnnotation) {
        map.setRegion(MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: .defaultRadius, longitudinalMeters: .defaultRadius), animated: true)
        map.selectAnnotation(annotation, animated: true)
    }
    
    func zoomToRegion(region: MKCoordinateRegion, animated: Bool) {
        map.setRegion(region, animated: animated)
    }
    
    // MARK: - MapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else {
            return nil
        }
        
        let identifier = NSStringFromClass(RestaurantAnnotation.self)
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        view.canShowCallout = false
        view.glyphImage = UIImage(named: "WingGlyph")
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? RestaurantAnnotation {
            let indexPath = IndexPath(row: 0, section: annotation.id)
            tableViewDelegate?.scrollToCell(indexPath: indexPath)
            
            activeCallout.updateRestaurant(restaurant: annotation.restaurant)

            self.view.addSubview(activeCallout)
            
            let calloutWidth:CGFloat = 150.0
            
            activeCallout.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10).isActive = true
            activeCallout.heightAnchor.constraint(lessThanOrEqualToConstant: 75).isActive = true
            activeCallout.widthAnchor.constraint(equalToConstant: calloutWidth).isActive = true
            
            //This check will make sure that the callout can fit on the (preferred) right side
            if (mapView.frame.maxX - view.frame.maxX) > calloutWidth + 15 {
                activeCallout.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15).isActive = true
            } else {
                activeCallout.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -15).isActive = true
            }
            
            activeCallout.layoutIfNeeded()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        activeCallout.removeConstraints(activeCallout.constraints)
        activeCallout.removeFromSuperview()
    }
}

//Helper class to store annotation with button. Helpful with #selector.
class AnnotationButton: UIButton {
    var annotation: RestaurantAnnotation?
}
