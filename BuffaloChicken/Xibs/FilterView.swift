//
//  FilterVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class FilterView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var filterByPicker: UIPickerView!
    @IBOutlet weak var maxDistanceSlider: UISlider!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var starButtonStack: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    
    var delegate: FindBuffaloChickenVCDelegate?
    
    private let filter = Filter()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxDistanceSlider.maximumValue = 10000.0
        maxDistanceSlider.minimumValue = 500.0
        
        self.filterByPicker.delegate = self
        self.filterByPicker.dataSource = self
        
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 25
        backgroundView.layer.borderColor = UIColor.systemGray3.cgColor
        backgroundView.layer.borderWidth = 1.0
        
        for (index, button) in starButtonStack.arrangedSubviews.enumerated() {
            if let button = button as? RatingStar {
                button.rating = index + 1
                button.addTarget(self, action: #selector(starPressed(_:)), for: .touchUpInside)
            }
        }
                
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
    }
    
    @objc func filterPressed() {
        filter.filterBy = FilterBy.allCases[filterByPicker.selectedRow(inComponent: 0)]
        filter.maxDistance = Double(maxDistanceSlider.value)
        
        guard let delegate = delegate else { return }
        delegate.filterAnnotations(filter: filter)
        delegate.switchFilterView()
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

class Filter {
    var filterBy: FilterBy = .nearest
    var isOpen = true
    var maxDistance: Double = 10000.0
    var minRating: Double = 0.0
}
