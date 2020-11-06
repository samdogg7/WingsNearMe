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
        map.layer.cornerRadius = 10
        return map
    }()
    
    var parentDelegate: FindWingsParentDelegate?
    var tableViewDelegate: FindWingsTableviewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(map)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 0)
            
            let hoursLabel = UILabel()
            hoursLabel.text = annotation.restaurant.isOpenString
            
            let mapsButton = AnnotationButton()
            mapsButton.setBackgroundImage(UIImage(named: "MapIcon"), for: .normal)
            mapsButton.annotation = annotation
            mapsButton.addTarget(self, action: #selector(self.openInMaps(_:)), for: .touchUpInside)
            mapsButton.translatesAutoresizingMaskIntoConstraints = false
            mapsButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            
            let detailsButton = AnnotationButton(type: .detailDisclosure)
            detailsButton.annotation = annotation as RestaurantAnnotation
            detailsButton.addTarget(self, action: #selector(self.openRestaurantDetailVC(_:)), for: .touchUpInside)
            
            let stack = UIStackView(arrangedSubviews: [hoursLabel, detailsButton, mapsButton])
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 5
            
            view.detailCalloutAccessoryView = stack
            
            view.glyphImage = UIImage(named: "WingGlyph")
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? RestaurantAnnotation {
            let indexPath = IndexPath(row: 0, section: annotation.id)
            tableViewDelegate?.scrollToCell(indexPath: indexPath)
        }
    }
    
    @objc func openInMaps(_ sender: AnnotationButton) {
        if let annotation = sender.annotation {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
            if let name = annotation.title {
                destination.name = name
            }
            
            MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}

//Helper class to store annotation with button. Helpful with #selector.
class AnnotationButton: UIButton {
    var annotation: RestaurantAnnotation?
}
