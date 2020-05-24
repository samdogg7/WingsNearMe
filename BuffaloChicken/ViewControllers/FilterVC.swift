//
//  FilterVC.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/24/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class FilterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var filterByPicker: UIPickerView!
    @IBOutlet weak var maxDistanceSlider: UISlider!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var starButtonStack: UIStackView!
    
    var delegate: FindBuffaloChickenVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in starButtonStack.arrangedSubviews {
            if let button = button as? UIButton {
//                button.addTarget(self, action: #selector(), for: .touchUpInside)
            }
        }
        
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
    }
    
    @objc func filterPressed() {
        let filter = Filter()
        
        filter.filterBy = FilterBy.allCases[filterByPicker.selectedRow(inComponent: 0)]
        filter.maxDistance = Double(maxDistanceSlider.value)
        
        
        guard let delegate = delegate else { return }
        delegate.filterAnnotations(filter: filter)
        dismiss(animated: true, completion: nil)
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
