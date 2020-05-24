//
//  ViewController.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CBFlashyTabBarController

protocol FindBuffaloChickenVCDelegate {
    func filterAnnotations(filter: Filter)
}

class FindBuffaloChickenVC: UIViewController, UITableViewDelegate,  UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, FindBuffaloChickenVCDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let cellId = "RestuarantCell"
    let testing_enabled = false
    let loadingView = LoadingView().loadNib() as! LoadingView
    let radius:Double = 10000
    let cellSpacingHeight: CGFloat = 5
    
    var lat:Double = 37.3230
    var long:Double = -122.0322
    var sortedAnnotations: [RestaurantAnnotation] = []
    var unsortedAnnotations: [RestaurantAnnotation] = []
    
    
    // MARK: - View handler Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        map.delegate = self
        
        setupSubviews()
    }
    
    
    func setupSubviews() {
        let tableViewNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        loadingView.frame = self.view.frame
        self.view.addSubview(loadingView)
    }
    
    // MARK: - API Request Methods
    
    func getPlaces() {
        APIManager().placesRequest(search_term: "wings", lat: lat, long: long, radius: radius, testing: testing_enabled, placesResponse: { response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            DispatchQueue.main.async {
                if let results = response {
                    self.getDetails(places: results)
                }
            }
        })
    }
    
    func getDetails(places: [Place]) {
        var places = places
        //Keep track of if a detail request is complete...
        var detailRequestComplete = Array(repeating: false, count: places.count)
        //For each place, get the place's detail
        for index in 0..<places.count {
            if let placeID = places[index].placeID {
                APIManager().placeDetailRequest(placeId: placeID, testing: testing_enabled, detailResponse: { response, error in
                    detailRequestComplete[index] = true
                    
                    if error != nil {
                        print(error?.localizedDescription ?? "Error")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let detail = response {
                            places[index].placeDetail = detail
                            //If all detail requests are done loading, add annotations
                            if !detailRequestComplete.contains(false) {
                                self.addAnnotations(places: places)
                            }
                        }
                    }
                })
            }
        }
    }
    
    
    func addAnnotations(places: [Place]) {
        for (index, place) in places.enumerated() {
            let annotation = RestaurantAnnotation(id: index, restaurant: Restaurant(place: place), userLocation: CLLocation(latitude: lat, longitude: long) )
            unsortedAnnotations.append(annotation)
        }
        filterAnnotations(filter: Filter())
        loadingView.hide()
    }
    
    // MARK: - FindBuffaloChickenVCDelegate methods
    
    func filterAnnotations(filter: Filter) {
        var sorted = unsortedAnnotations
        
        if(filter.isOpen) {
            sorted = sorted.filter({ $0.restaurant.isOpen })
        }
        sorted = sorted.filter({ $0.distance <= filter.maxDistance })
        sorted = sorted.filter({ $0.restaurant.rating >= filter.minRating })

        switch filter.filterBy {
        case .rating:
            sorted.sort(by: { ($0.restaurant.rating) < ($1.restaurant.rating) })
        //Nearest by default
        default:
            sorted.sort(by: { ($0.distance) < ($1.distance) })
        }
        
        for i in 0..<sorted.count {
            sorted[i].id = i
        }
        
        sortedAnnotations = sorted
        reloadSubviews()
    }
    
    func reloadSubviews() {
        map.removeAnnotations(map.annotations)
        map.addAnnotations(sortedAnnotations)
        tableView.reloadData()
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
    
    //MARK: - Segue methods
    
    func openRestaurantDetailVC(restaurant: Restaurant) {
        performSegue(withIdentifier: "ShowRestaurantDetail", sender: restaurant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurant = sender as? Restaurant else { return }
        
        if let target = segue.destination as? RestauarantDetailVC {
            target.restaurant = restaurant
        }
    }
    
    // MARK: - LocationManager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = manager.location?.coordinate.latitude, let long = manager.location?.coordinate.longitude {
            self.lat = lat
            self.long = long
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: radius*2, longitudinalMeters: radius*2), animated: true)
            getPlaces()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            getPlaces()
        }
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
            
            let mapsButton = AnnotationButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(UIImage(named: "MapIcon"), for: .normal)
            mapsButton.annotation = annotation
            mapsButton.addTarget(self, action: #selector(self.openInMaps(_:)), for: .touchUpInside)
            
            view.rightCalloutAccessoryView = mapsButton
            view.glyphImage = UIImage(named: "WingGlyph")
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? RestaurantAnnotation {
            let indexPath = IndexPath(row: 0, section: annotation.id)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = sortedAnnotations[indexPath.section].restaurant
        
        cell.layer.borderColor = UIColor(named: "InverseSystem")?.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedAnnotations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.section).")
        map.setRegion(MKCoordinateRegion(center: sortedAnnotations[indexPath.section].coordinate, latitudinalMeters: radius, longitudinalMeters: radius), animated: true)
        let annotation = sortedAnnotations[indexPath.section]
        map.selectAnnotation(annotation, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        openRestaurantDetailVC(restaurant: annotation.restaurant)
    }
}

class AnnotationButton: UIButton {
    var annotation: MKAnnotation?
}

