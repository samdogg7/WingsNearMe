//
//  AWXSwipableCollectionViewCell.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/25/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class AWXSwipableCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, ReusableIdentifier {
    var infiniteScrolling = true
    var scrollViewTopAnchorConstraint: NSLayoutConstraint?
    
    //The scrollview contains all the subviews we wish to 'swipe' through
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .green
        control.pageIndicatorTintColor = .systemPink
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var views: [UIView] = {
       return [UIView]()
    }()
    
    func addSubViewsToScrollView(views: [UIView], infiniteScrolling: Bool = true) {
        self.views = views
        self.infiniteScrolling = infiniteScrolling
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews()
        reloadScrollView()
    }
    
    func setupSubviews() {
        pageControl.numberOfPages = views.count
        self.contentView.addSubview(scrollView)
        self.contentView.addSubview(pageControl)
        self.backgroundColor = .white
        self.addRoundedCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollViewTopAnchorConstraint = scrollView.topAnchor.constraint(equalTo: contentView.topAnchor)
        scrollViewTopAnchorConstraint?.isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func reloadScrollView() {
        guard views.count > 0 else { return }
        layoutIfNeeded()
        
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var frame = CGRect.zero
        
        for index in 0..<views.count {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size

            let view = views[index]
            view.frame = frame

            scrollView.addSubview(view)
        }
        
        scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(views.count), height: self.scrollView.frame.size.height)
        if infiniteScrolling {
            scrollView.contentOffset.x = 0
            calculateOffset(initialLoad: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if infiniteScrolling {
            calculateOffset()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !infiniteScrolling {
           let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            if page <= views.count && page >= 0 {
                pageControl.currentPage = page
            }
        }
    }
    
    func calculateOffset(initialLoad: Bool = false) {
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5) {
            let first = views.remove(at: 0)
            views.append(first)
            layoutViews()
            scrollView.contentOffset.x -= scrollView.frame.width
            if pageControl.currentPage == pageControl.numberOfPages - 1 {
                pageControl.currentPage = 0
            } else {
                pageControl.currentPage += 1
            }
        } else if (offsetX < scrollView.frame.size.width * 0.5) {
            let last = views.remove(at: views.count-1)
            views.insert(last, at: 0)
            layoutViews()
            scrollView.contentOffset.x += scrollView.frame.width
            if !initialLoad {
                if pageControl.currentPage == 0 {
                    pageControl.currentPage = pageControl.numberOfPages - 1
                } else {
                    pageControl.currentPage -= 1
                }
            }
        }
    }
    
    private func layoutViews() {
        let width = scrollView.frame.size.width
        for (index, view) in views.enumerated() {
            view.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: scrollView.frame.size.height)
        }
    }
}
