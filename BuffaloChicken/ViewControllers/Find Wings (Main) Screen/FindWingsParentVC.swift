//
//  FindWingsParentVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Lottie
import FirebaseDatabase

protocol FindWingsParentDelegate {
    func filterAnnotations(filter: Filter)
    func switchFilterView()
}

class FindWingsParentVC: UIViewController, CLLocationManagerDelegate, FindWingsParentDelegate {
    private let databaseRef = Database.database().reference(withPath: "Restaurant-Reviews")
    
    private lazy var settingsVC: SettingsVC = {
        return SettingsVC()
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(switchFilterView))
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
    }()
    
    private lazy var mapVC: FindWingsMapVC = {
        let vc = FindWingsMapVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        self.mapDelegate = vc
        return vc
    }()
    
    private lazy var tableviewVC: FindWingsTableviewVC = {
        let vc = FindWingsTableviewVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewDelegate = vc
        return vc
    }()
    
    private var mapDelegate: FindWingsMapDelegate?
    private var tableViewDelegate: FindWingsTableviewDelegate?

    private let locationManager = CLLocationManager()
    private let filterView = FilterView().loadNib() as! FilterView
    
    private var unsortedAnnotations: [RestaurantAnnotation] = []
    private var nearestLocation: RestaurantAnnotation?
    private var filter = Filter()
    
    private lazy var loadingAlert = LoadingAlert(title: "Loading Tenders...", message: "", preferredStyle: .alert)

    private var lat:Double = .defaultLatitude
    private var long:Double = .defaultLongitude

    // MARK: - View handler Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Wings near me"
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.leftBarButtonItem = settingsButton
        
        view.backgroundColor = .white
        
        locationManager.delegate = self
        filterView.delegate = self
        
        setupSubviews()
        setupSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.present(loadingAlert, animated: true, completion: nil)
        
        #if targetEnvironment(simulator)
        self.getPlaces()
        #else
        if UserDefaults.standard.bool(forKey: .isTestingKey), CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startMonitoringSignificantLocationChanges()
        #endif
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        mapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        mapVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        mapVC.view.heightAnchor.constraint(equalToConstant: 165).isActive = true
        
        tableviewVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        tableviewVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        tableviewVC.view.topAnchor.constraint(equalTo: mapVC.view.bottomAnchor).isActive = true
        tableviewVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupSubviews() {
        addChild(mapVC)
        view.addSubview(mapVC.view)
        mapVC.didMove(toParent: self)
        mapVC.parentDelegate = self
        mapVC.tableViewDelegate = tableviewVC
        
        addChild(tableviewVC)
        view.addSubview(tableviewVC.view)
        tableviewVC.didMove(toParent: self)
        tableviewVC.parentDelegate = self
        
        filterView.isHidden = true
        filterView.frame = self.view.frame
        filterView.setMaxDistance(d: .defaultRadius)
        self.view.addSubview(filterView)
    }
    
    func setupSettings() {
        if UserDefaults.standard.object(forKey: .isTestingKey) == nil {
            UserDefaults.standard.set(true, forKey: .isTestingKey)
        }
        
        print("API testing enabled: \(UserDefaults.standard.bool(forKey: .isTestingKey))")
    }
    
    // MARK: - API Request Methods
    
    @objc func getPlaces() {
        unsortedAnnotations.removeAll()
        
        //If testing is enabled, use default init. Otherwise, give params.
        let request = UserDefaults.standard.bool(forKey: .isTestingKey) ? PlacesRequest() : PlacesRequest(query: "wings", lat: lat, long: long, radius: .defaultRadius)
            
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
        var restaurants:[Restaurant] = []
        let dispatchGroup = DispatchGroup()
        
        //For each place, get the place's detail
        for index in 0..<places.count {
            restaurants.append(Restaurant(place: places[index]))
            
            if let placeID = places[index].placeID {
                let request = DetailRequest(placeId: placeID, testing: UserDefaults.standard.bool(forKey: .isTestingKey))
                
                APIManager.request(request: request, responseType: DetailResponse.self, dispatchGroup: dispatchGroup, completion: { response in
                    switch response {
                    case .success(let data):
                        if let detail = data.result {
                            restaurants[index].addDetails(details: detail)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
            if let photoID = places[index].photos?.first?.photoReference {
                APIManager.request(request: PhotoRequest(photoId: photoID, testing: UserDefaults.standard.bool(forKey: .isTestingKey)), responseType: PhotoResponse.self, dispatchGroup: dispatchGroup, completion: { response in
                    switch response {
                    case .success(let photo):
                        restaurants[index].addPhoto(photo: photo, atIndex: 0)
                    case .failure(_):
                        restaurants[index].addPhoto(photo: UIImage(named: "PlaceholderWing")!)
                    }
                })
            } else {
                restaurants[index].addPhoto(photo: UIImage(named: "PlaceholderWing")!)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.addAnnotations(retaurants: restaurants)
        }
    }
    
    
    func addAnnotations(retaurants: [Restaurant]) {
        for (index, restaurant) in retaurants.enumerated() {
            let annotation = RestaurantAnnotation(id: index, restaurant: restaurant, userLocation: CLLocation(latitude: lat, longitude: long) )
            unsortedAnnotations.append(annotation)
        }
        
        filterAnnotations(filter: filter)
    }
    
    // MARK: - FindBuffaloChickenVCDelegate methods
    
    func filterAnnotations(filter: Filter) {
        var sorted = unsortedAnnotations
        
        if(filter.isOpen) {
            sorted = sorted.filter({ $0.restaurant.isOpen })
        }
        sorted = sorted.filter({ $0.distance <= filter.maxDistance })
        nearestLocation = sorted.first
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
        
        reloadSubviews(annotations: sorted)
    }
    
    func reloadSubviews(annotations: [RestaurantAnnotation]) {
        mapDelegate?.addAnnotations(annotations: annotations)
        
        self.dismiss(animated: true, completion: {
            self.tableViewDelegate?.addCells(cells: annotations)
            self.tableViewDelegate?.animateTableCells(fromBottom: true)
        })
    }
    
    //MARK: - Filter View helper methods
    
    @objc func switchFilterView() {
        filterView.isHidden = !filterView.isHidden
        if !filterView.isHidden {
            filterButton.title = "Cancel"
        } else {
            filterButton.title = "Filter"
            self.tableViewDelegate?.animateTableCells(fromBottom: false)
        }
    }
    
    //MARK: - Setting button helper method
    
    @objc func openSettings() {
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    // MARK: - LocationManager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = manager.location?.coordinate.latitude, let long = manager.location?.coordinate.longitude {
            self.lat = lat
            self.long = long
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: .defaultRadius*2, longitudinalMeters: .defaultRadius*2)
            mapDelegate?.zoomToRegion(region: region, animated: true)
            
            getPlaces()
            
            //Stop updating location. Ideally we do not want this, but do not want to get charged for billing
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            getPlaces()
        }
    }
}
