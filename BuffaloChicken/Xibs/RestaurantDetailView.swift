//
//  RestaurantDetailView.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/7/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Lottie
import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UIScrollViewDelegate {
    private lazy var pullDownIndicatorView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .orange
        return control
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.text = "Hours"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Location", for: .normal)
        button.addTarget(self, action: #selector(pressedLocationButton), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var ratingStacks: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = "Reviews"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var chickenRatingStack: RatingStack = {
        let stack = RatingStack(switchType: .chicken, touchEnabled: false, countEnabled: 4)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var spiceRatingStack: RatingStack = {
        let stack = RatingStack(switchType: .spice, touchEnabled: false, countEnabled: 5)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sauceRatingStack: RatingStack = {
        let stack = RatingStack(switchType: .sauce, touchEnabled: false, countEnabled: 4)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var friesRatingStack: RatingStack = {
        let stack = RatingStack(switchType: .fries, touchEnabled: false, countEnabled: 3)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var previousBorderLayer: CAShapeLayer?
    
    var tableViewDelegate: FindWingsTableviewDelegate?
    
    var restaurant: Restaurant? {
        didSet {
            setup()
        }
    }
    
    var scrollViewImages: [UIImage] = []
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        view.addSubview(mainStack)
        view.addSubview(pullDownIndicatorView)
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(hoursLabel)
        mainStack.addArrangedSubview(locationButton)
        mainStack.addArrangedSubview(ratingStacks)
        
        ratingStacks.addArrangedSubview(ratingLabel)
        ratingStacks.addArrangedSubview(chickenRatingStack)
        ratingStacks.addArrangedSubview(spiceRatingStack)
        ratingStacks.addArrangedSubview(sauceRatingStack)
        ratingStacks.addArrangedSubview(friesRatingStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pullDownIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        pullDownIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullDownIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullDownIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        pullDownIndicatorView.addRoundedCorners(radius: pullDownIndicatorView.bounds.height)
        
        scrollView.topAnchor.constraint(equalTo: pullDownIndicatorView.bottomAnchor, constant: 5).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true

        mainStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -5).isActive = true
        
        previousBorderLayer?.removeFromSuperlayer()
        previousBorderLayer = view.addRoundedCorners(radius: 10, corners: [.topRight, .topLeft], borderWidth: 2, borderColor: .lightGray)
    }
    
    func setup() {
        guard let _restaurant = restaurant else { return }
        
        pageControl.numberOfPages = _restaurant.photos.count
        
        nameLabel.text = _restaurant.name + " - " + _restaurant.isOpenString
        hoursLabel.text = _restaurant.hoursString
        locationButton.setTitle(_restaurant.formattedAddress, for: .normal)
        
        setPage(index: 0, animated: false)
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var frame = CGRect.zero
        
        for index in 0..<_restaurant.photos.count {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size


            let imgView = UIImageView(image: _restaurant.photos[index])
            imgView.contentMode = .scaleAspectFit
            imgView.frame = frame
            imgView.roundCornersForAspectFit(radius: .defaultCornerRadius)

            scrollView.addSubview(imgView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(_restaurant.photos.count), height: self.scrollView.frame.size.height)
        self.pageControl.addTarget(self, action: #selector(pageChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func closeView() {
        if let delegate = tableViewDelegate {
            delegate.hideRestaurantDetail(completion: nil)
        }
    }
    
    func setPage(index: Int, animated: Bool = true) {
        pageControl.currentPage = index
        let xVal = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: animated)
    }
    
    @objc func pageChanged() {
        let xVal = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func pressedLocationButton() {
        if let _restaurant = restaurant {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: _restaurant.coordinate))
            destination.name = _restaurant.name
            MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
