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
    private lazy var mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
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
        view.backgroundColor = .lightGray
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
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .orange
        return control
    }()
    
    private lazy var infoStack: UIStackView = {
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
    
    var startingConstantPosY: CGFloat = 0.0
    var restaurant: Restaurant?
    var scrollViewImages: [UIImage] = []
    
    required init(restaurant: Restaurant) {
        super.init(nibName: nil, bundle: nil)
        
        self.restaurant = restaurant
        
        view.backgroundColor = .white
        
        view.addSubview(pullDownIndicatorView)
        view.addSubview(mainScrollView)
        view.addSubview(pullDownView)
        
        mainScrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(horzImageScrollView)
        contentStackView.addArrangedSubview(infoStack)
        contentStackView.addArrangedSubview(ratingStacks)

        view.addSubview(pageControl)
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(hoursLabel)
        infoStack.addArrangedSubview(locationButton)
        
        ratingStacks.addArrangedSubview(ratingLabel)
        ratingStacks.addArrangedSubview(chickenRatingStack)
        ratingStacks.addArrangedSubview(spiceRatingStack)
        ratingStacks.addArrangedSubview(sauceRatingStack)
        ratingStacks.addArrangedSubview(friesRatingStack)
        
        setup()
        
        view.bringSubviewToFront(pullDownView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainScrollView.topAnchor.constraint(equalTo: pullDownIndicatorView.bottomAnchor, constant: 5).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true

        pullDownView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        pullDownView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pullDownView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pullDownView.bottomAnchor.constraint(equalTo: pullDownIndicatorView.bottomAnchor, constant: 5).isActive = true
        
        pullDownIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        pullDownIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullDownIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullDownIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        pullDownIndicatorView.addRoundedCorners(radius: pullDownIndicatorView.bounds.height)
        
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
        
        self.horzImageScrollView.contentSize = CGSize(width:self.horzImageScrollView.frame.size.width * CGFloat(restaurant?.photos.count ?? 0), height: self.horzImageScrollView.frame.size.height)
    }
    
    func setup() {
        guard let _restaurant = restaurant else { return }
        pageControl.numberOfPages = _restaurant.photos.count
        
        nameLabel.text = _restaurant.name + " - " + _restaurant.isOpenString
        hoursLabel.text = _restaurant.hoursString
        locationButton.setTitle(_restaurant.formattedAddress, for: .normal)
        
        setPage(index: 0, animated: false)
        
        for index in 0..<_restaurant.photos.count {
            let imgView = UIImageView(image: _restaurant.photos[index])
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
        if let _restaurant = restaurant {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: _restaurant.coordinate))
            destination.name = _restaurant.name
            MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        if let slidablePC = self.presentationController as? SwipeablePresentationController {
            if sender.state == .began {
                startingConstantPosY =  slidablePC.translationConstraint?.constant ?? 0.0
            } else if sender.state == .changed {
                slidablePC.translationConstraint?.constant = startingConstantPosY + sender.translation(in: self.view).y
            } else if sender.state == .ended {
                if sender.velocity(in: view).y >= 1250 {
                    self.dismiss(animated: true, completion: nil)
                } else {
//                    UIView.animate(withDuration: 0.3) {
//                        self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
//                    }
                }
            }
        }
    }
}
