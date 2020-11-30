//
//  RestaurantDetailView.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/7/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Lottie
import UIKit

class RestaurantDetailView: UIView, UIScrollViewDelegate {
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
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.text = "Hours"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        return label
    }()
    
    private lazy var chickenRatingStack: RatingStack = {
        let stack = RatingStack(switchType: .chicken)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.addSubview(mainStack)
        self.addSubview(pullDownIndicatorView)
        self.addSubview(pageControl)
        self.addSubview(scrollView)
        
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(hoursLabel)
        mainStack.addArrangedSubview(locationLabel)
        mainStack.addArrangedSubview(chickenRatingStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pullDownIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        pullDownIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pullDownIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pullDownIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        pullDownIndicatorView.addRoundedCorners(radius: pullDownIndicatorView.bounds.height)
        
        scrollView.topAnchor.constraint(equalTo: pullDownIndicatorView.bottomAnchor, constant: 5).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true

        mainStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        previousBorderLayer?.removeFromSuperlayer()
        previousBorderLayer = self.addRoundedCorners(radius: 10, corners: [.topRight, .topLeft], borderWidth: 2, borderColor: .lightGray)
    }
    
    func setup() {
        guard let _restaurant = restaurant else { return }
        
        pageControl.numberOfPages = _restaurant.photos.count
        
        nameLabel.text = _restaurant.name + " - " + _restaurant.isOpenString
        hoursLabel.text = _restaurant.hoursString
        locationLabel.text = _restaurant.formattedAddress
        
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
}
