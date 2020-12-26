//
//  FilterVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class FilterView: UIView {
    @IBOutlet weak var filterBySegment: UISegmentedControl!
    @IBOutlet weak var maxDistanceSlider: UISlider!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var starButtonStack: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var isOpenSegment: UISegmentedControl!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var delegate: FindWingsParentDelegate?
    
    private let filter = Filter()
        
    override func awakeFromNib() {
        super.awakeFromNib()
                
        maxDistanceSlider.maximumValue = 12070.0
        maxDistanceSlider.minimumValue = 500.0
        maxDistanceSlider.value = 8046.72 //5 miles in meters
        
        backgroundView.addRoundedCorners(corners: .allCorners)
        
        filterButton.layer.masksToBounds = true
        filterButton.layer.cornerRadius = filterButton.frame.height / 2
        filterButton.addBorder(color: UIColor.systemGray3, width: 1)
        
        filterBySegment.apportionsSegmentWidthsByContent = false
        isOpenSegment.apportionsSegmentWidthsByContent = false

        filterBySegment.removeAllSegments()
        for (index, filterType) in FilterBy.allCases.enumerated() {
            filterBySegment.insertSegment(withTitle: filterType.rawValue, at: index, animated: false)
        }
        filterBySegment.selectedSegmentIndex = 0
        
        for (index, button) in starButtonStack.arrangedSubviews.enumerated() {
            if let button = button as? RatingStar {
                button.rating = index + 1
                button.addTarget(self, action: #selector(starPressed(_:)), for: .touchUpInside)
            }
        }
                
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        maxDistanceSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        sliderValueChanged()
    }
    
    @objc func filterPressed() {
        filter.filterBy = FilterBy.allCases[filterBySegment.selectedSegmentIndex]
        filter.maxDistance = Double(round(maxDistanceSlider.value))
        filter.isOpen = isOpenSegment.selectedSegmentIndex == 0
        
        guard let _delegate = delegate else { return }
        
        _delegate.filterAnnotations(filter: filter)
        _delegate.switchFilterView()
    }
    
    @objc func sliderValueChanged() {
        let miles = String(format: "%.1f", (maxDistanceSlider.value * 0.00062137))
        distanceLabel.text = miles + " Miles"
    }
    
    @objc func starPressed(_ sender: RatingStar) {
        if let minRating = sender.rating {
            filter.minRating = Double(minRating)
            if let stars = starButtonStack.arrangedSubviews as? [RatingStar] {
                for (index, star) in stars.enumerated() {
                    star.setImage(UIImage(systemName: "star"), for: .normal)
                    if index < minRating {
                        star.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                }
            }
        }
    }
    
    func setMaxDistance(d: Double) {
        maxDistanceSlider.maximumValue = Float(d)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FilterBy.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FilterBy.allCases[row].rawValue
    }
}

class RatingStar: UIButton {
    var rating: Int?
}

enum FilterBy: String, CaseIterable {
    case nearest = "Nearest"
    case rating = "Rating"
}

@objcMembers class Filter {
    var filterBy: FilterBy = .nearest
    var isOpen = true
    var maxDistance: Double = 10000.0
    var minRating: Double = 0.0
}
