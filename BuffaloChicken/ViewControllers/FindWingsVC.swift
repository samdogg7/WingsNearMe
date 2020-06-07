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
import Lottie
import ViewAnimator
import SideMenu

protocol FindBuffaloChickenVCDelegate {
    func filterAnnotations(filter: Filter)
    func openRestaurantDetailVC(restaurant: Restaurant)
    func switchFilterView()
}

class FindWingsVC: UIViewController, UITableViewDelegate,  UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, FindBuffaloChickenVCDelegate, SideMenuNavigationControllerDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    private let locationManager = CLLocationManager()
    private let filterView = FilterView().loadNib() as! FilterView
    
    private var sortedAnnotations: [RestaurantAnnotation] = []
    private var unsortedAnnotations: [RestaurantAnnotation] = []
    private var filter = Filter()
    
    private lazy var loadingAlert = LoadingAlert(title: "Loading Tenders...", message: "", preferredStyle: .alert)

    private var lat:Double = .defaultLatitude
    private var long:Double = .defaultLongitude
    private let radius:Double = .defaultRadius
    
    private let cellSpacingHeight: CGFloat = 10
    private let cellId = "RestuarantCell"
    
    // MARK: - View handler Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.present(loadingAlert, animated: true, completion: nil)
        
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        map.delegate = self
        filterView.delegate = self
        
        setupSubviews()
        setupSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func setupSubviews() {
        let tableViewNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        
        map.layer.masksToBounds = true
        map.layer.cornerRadius = 10
        
        filterButton.target = self
        filterButton.action = #selector(switchFilterView)
        
        filterView.isHidden = true
        filterView.frame = self.view.frame
        filterView.setMaxDistance(d: radius)
        self.view.addSubview(filterView)
    }
    
    func setupSettings() {
        if UserDefaults.standard.object(forKey: .testing_enabled) == nil {
            UserDefaults.standard.set(true, forKey: .testing_enabled)
        }
    }
    
    // MARK: - API Request Methods
    
    @objc func getPlaces() {
        unsortedAnnotations.removeAll()
        
        //If testing is enabled, use default init. Otherwise, give params.
        let request = UserDefaults.standard.bool(forKey: .testing_enabled) ? PlacesRequest() : PlacesRequest(query: "wings", lat: lat, long: long, radius: radius)
            
        APIManager.request(request: request, responseType: PlacesResponse.self, completion: { response in
            switch response {
            case .success(let data):
                if let results = data.results {
                    self.getDetails(places: results)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getDetails(places: [Place]) {
        var places = places
        let dispatchGroup = DispatchGroup()
        
        //For each place, get the place's detail
        for index in 0..<places.count {
            if let placeID = places[index].placeID {
                let request = DetailRequest(placeId: placeID, testing: UserDefaults.standard.bool(forKey: .testing_enabled))
                
                APIManager.request(request: request, responseType: DetailResponse.self, dispatchGroup: dispatchGroup, completion: { response in
                    switch response {
                    case .success(let data):
                        places[index].placeDetail = data.result
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
            if let photoID = places[index].photos?.first?.photoReference {
                APIManager.request(request: PhotoRequest(photoId: photoID, testing: UserDefaults.standard.bool(forKey: .testing_enabled)), responseType: PhotoResponse.self, dispatchGroup: dispatchGroup, completion: { response in
                    switch response {
                    case .success(let photo):
                        places[index].downloadedPhoto = photo
                    case .failure(_):
                        places[index].downloadedPhoto = UIImage(named: "PlaceholderWing")!
                    }
                })
            } else {
                places[index].downloadedPhoto = UIImage(named: "PlaceholderWing")!
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.addAnnotations(places: places)
        }
    }
    
    
    func addAnnotations(places: [Place]) {
        for (index, place) in places.enumerated() {
            let annotation = RestaurantAnnotation(id: index, restaurant: Restaurant(place: place), userLocation: CLLocation(latitude: lat, longitude: long) )
            unsortedAnnotations.append(annotation)
        }
        
        filterAnnotations(filter: filter)
    }
    
    func animateTableCells() {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            var cells:[RestaurantTableViewCell] = []
            for indexPath in indexPaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell {
                    cells.append(cell)
                }
            }
            UIView.animate(views: cells, animations: [AnimationType.from(direction: .bottom, offset: 100.0)], duration: 1.5)
        }
    }
    
    // MARK: - FindBuffaloChickenVCDelegate methods
    
    func filterAnnotations(filter: Filter) {
        sortedAnnotations = []
        var sorted = unsortedAnnotations
        
        if(filter.isOpen) {
            sorted = sorted.filter({ $0.restaurant.isOpen })
        }
        sorted = sorted.filter({ $0.distance <= filter.maxDistance })
        sorted = sorted.filter({ $0.restaurant.rating >= filter.minRating })

        switch filter.filterBy {
        case .rating:
            sorted.sort(by: { ($0.restaurant.rating) > ($1.restaurant.rating) })
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
        map.showAnnotations(map.annotations, animated: true)
        
        self.dismiss(animated: true, completion: {
            self.tableView.reloadData()
            self.animateTableCells()
        })
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
    
    @objc func openRestaurantDetailVC(_ sender: AnnotationButton) {
        performSegue(withIdentifier: "ShowRestaurantDetail", sender: sender.annotation?.restaurant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let restaurant = sender as? Restaurant {
            if let target = segue.destination as? RestauarantDetailVC {
                target.restaurant = restaurant
            }
        } else if let sideMenuNavigationController = segue.destination as? SideMenuNavigationController {
            sideMenuNavigationController.sideMenuDelegate = self
        }
    }
    
    //MARK: - Filter View helper methods
    
    @objc func switchFilterView() {
        filterView.isHidden = !filterView.isHidden
        if !filterView.isHidden {
            filterButton.title = "Cancel"
        } else {
            filterButton.title = "Filter"
            animateTableCells()
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
            
            let hoursLabel = UILabel()
            hoursLabel.text = annotation.restaurant.hoursString
            
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
        let restaurant = sortedAnnotations[indexPath.section].restaurant
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = restaurant
        
        cell.layer.borderColor = UIColor(named: "InverseSystem")?.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedAnnotations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        map.setRegion(MKCoordinateRegion(center:sortedAnnotations[indexPath.section].coordinate, latitudinalMeters: radius, longitudinalMeters: radius), animated: true)
        let annotation = sortedAnnotations[indexPath.section]
        map.selectAnnotation(annotation, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//Helper class to store annotation with button. Helpful with #selector.
class AnnotationButton: UIButton {
    var annotation: RestaurantAnnotation?
}
