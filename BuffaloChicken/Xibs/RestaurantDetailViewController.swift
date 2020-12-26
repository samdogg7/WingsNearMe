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

class RestaurantDetailViewController: UIViewController, UIScrollViewDelegate, InteractableFullRatingStackDelegate {
    private lazy var mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pullDownView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction)))
        return view
    }()
    
    private lazy var pullDownIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondary
        return view
    }()
    
    private lazy var horzImageScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = .tertiary
        control.currentPageIndicatorTintColor = .orange
        return control
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .primary
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.text = "Hours"
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .secondary
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Location", for: .normal)
        button.addTarget(self, action: #selector(pressedLocationButton), for: .touchUpInside)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var ratingHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private lazy var ratingHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = "Average Ratings"
        label.textAlignment = .left
        label.textColor = .primary
        return label
    }()
    
    private lazy var personalRatingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = "Tap to add your own ratings"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .primary
        return label
    }()
    
    private lazy var ratingContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 7.5
        return stack
    }()
    
    private lazy var previousReviewsStack: StaticFullRatingStack = {
        let ratingStack = StaticFullRatingStack()
        ratingStack.setStackEnabled(stackType: .chicken, countEnabled: 4)
        ratingStack.setStackEnabled(stackType: .spice, countEnabled: 3)
        ratingStack.setStackEnabled(stackType: .sauce, countEnabled: 5)
        ratingStack.setStackEnabled(stackType: .sides, countEnabled: 4)
        return ratingStack
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var userReviewsStack: InteractableFullRatingStack = {
        return InteractableFullRatingStack(delegate: self)
    }()
    
    private lazy var moreComingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = "More in depth the ratings/review process coming soon"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "MapIcon"), for: .normal)
        button.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        return button
    }()
   
    var startingConstantPosY: CGFloat = 0.0
    var restaurant: Restaurant
    var scrollViewImages: [UIImage] = []
    var initialHeight: CGFloat
    
    required init(restaurant: Restaurant, initialHeight: CGFloat) {
        self.restaurant = restaurant
        self.initialHeight = initialHeight
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .background
        
        view.addSubview(pullDownIndicatorView)
        view.addSubview(mainScrollView)
        view.addSubview(pullDownView)
        
        mainScrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(horzImageScrollView)
        contentStackView.addArrangedSubview(infoStack)
        contentStackView.addArrangedSubview(ratingHeaderStack)
        contentStackView.addArrangedSubview(ratingContentStack)
        contentStackView.addArrangedSubview(moreComingSoonLabel)
        
        view.addSubview(pageControl)
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(hoursLabel)
        infoStack.addArrangedSubview(locationButton)
        
        ratingHeaderStack.addArrangedSubview(ratingHeaderLabel)
        ratingHeaderStack.addArrangedSubview(personalRatingsLabel)
        
        ratingContentStack.addArrangedSubview(previousReviewsStack)
        ratingContentStack.addArrangedSubview(spacer)
        ratingContentStack.addArrangedSubview(separator)
        ratingContentStack.addArrangedSubview(userReviewsStack)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        mainScrollView.topAnchor.constraint(equalTo: pullDownView.bottomAnchor).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        if let presentingController = self.presentationController as? SlidePresentationController, let constraint = presentingController.containerView?.bottomAnchor {
            mainScrollView.bottomAnchor.constraint(equalTo: constraint).isActive = true
        } else {
            mainScrollView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
        
        contentStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true

        pullDownView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pullDownView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pullDownView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pullDownView.bottomAnchor.constraint(equalTo: pullDownIndicatorView.bottomAnchor, constant: 10).isActive = true
        
        pullDownIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        pullDownIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullDownIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullDownIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        pullDownIndicatorView.addRoundedCorners(radius: pullDownIndicatorView.bounds.height)
        
        view.bringSubviewToFront(pullDownView)
        
        horzImageScrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: horzImageScrollView.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: horzImageScrollView.bottomAnchor, constant: -25).isActive = true
        
        var emptyFrame = CGRect.zero

        for (index, subview) in horzImageScrollView.subviews.enumerated() where subview is UIImageView {
            guard let imgView = subview as? UIImageView else { return }
            emptyFrame.origin.x = self.horzImageScrollView.frame.size.width * CGFloat(index)
            emptyFrame.size = self.horzImageScrollView.frame.size
            imgView.frame = emptyFrame
            imgView.roundCornersForAspectFit(radius: .defaultCornerRadius)
        }
        
        self.horzImageScrollView.contentSize = CGSize(width:self.horzImageScrollView.frame.size.width * CGFloat(restaurant.photos.count), height: self.horzImageScrollView.frame.size.height)
        
        separator.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    func setup() {
        pageControl.numberOfPages = restaurant.photos.count
        
        nameLabel.text = restaurant.name + " - " + restaurant.isOpenString
        hoursLabel.text = restaurant.hoursString
        locationButton.setTitle(restaurant.formattedAddress, for: .normal)
        
        setPage(index: 0, animated: false)
        
        for index in 0..<restaurant.photos.count {
            let imgView = UIImageView(image: restaurant.photos[index])
            imgView.contentMode = .scaleAspectFit
            horzImageScrollView.addSubview(imgView)
        }
        
        self.pageControl.addTarget(self, action: #selector(pageChanged), for: UIControl.Event.valueChanged)
    }
    
    func setPage(index: Int, animated: Bool = true) {
        pageControl.currentPage = index
        let xVal = CGFloat(pageControl.currentPage) * horzImageScrollView.frame.size.width
        horzImageScrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: animated)
    }
    
    @objc func pageChanged() {
        let xVal = CGFloat(pageControl.currentPage) * horzImageScrollView.frame.size.width
        horzImageScrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func pressedLocationButton() {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
        destination.name = restaurant.name
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        if let slidePresentationController = self.presentationController as? SlidePresentationController {
            
            if sender.state == .began {
                startingConstantPosY =  slidePresentationController.translationConstraint?.constant ?? 0.0
            }
            let constant = startingConstantPosY + sender.translation(in: self.view).y
            
            if sender.state == .changed {
                slidePresentationController.translationConstraint?.constant = constant
            } else if sender.state == .ended {
                if sender.velocity(in: view).y >= 1250 {
                    dismissTriggered()
                } else {
                    if view.bounds.height > initialHeight && constant < 0 {
                        slidePresentationController.updateContainerViewTopAnchor(.upper)
                    } else {
                        slidePresentationController.updateContainerViewTopAnchor(.middle)
                    }
                }
            }
        }
    }
    
    func reviewSubmit() {
        FirebaseReviewHandler.addRestaurantReview(placeId: restaurant.placeID, userReview: userReviewsStack.getReviews())
    }
    
    func dismissTriggered() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openInMaps() {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
        destination.name = restaurant.name
        
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
