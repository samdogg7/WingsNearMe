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
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    var tableViewDelegate: FindWingsTableviewDelegate?
    var previousBorderLayer: CAShapeLayer?
    
    var restaurant: Restaurant? {
        didSet {
            setup()
        }
    }
    
    var scrollViewImages: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previousBorderLayer?.removeFromSuperlayer()
        previousBorderLayer = self.addRoundedCorners(radius: .defaultCornerRadius + 5, corners: [ .topLeft, .topRight ], borderWidth: 1, borderColor: .separator)

        self.bringSubviewToFront(pageControl)
        self.bringSubviewToFront(closeButton)
    }
    
    func setup() {
        guard let _restaurant = restaurant else { return }
        
        pageControl.numberOfPages = _restaurant.photos.count
        
        name.text = _restaurant.name + " - " + _restaurant.isOpenString
        hours.text = _restaurant.hoursString
        self.location.text = _restaurant.formattedAddress
        
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
        
        let chickenButtonStack = UIStackView()
        chickenButtonStack.distribution = .fillEqually
        
        mainStack.addArrangedSubview(chickenButtonStack)
        
        for _ in 0..<5 {
            guard let animation = Animation.named("chicken-icon") else { return  }
            let lottieSwitch = LottieSwitch(animation: animation, animated: true, backgroundImage: UIImage(named: "Empty Wing"))
            chickenButtonStack.addSubview(lottieSwitch)
        }
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
