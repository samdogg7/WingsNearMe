//
//  MapCustomCallout.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 12/26/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class MapCustomCallout: UIView {
    private var restaurant: Restaurant?
    var delegate: FindWingsTableviewDelegate?
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(detailsButtonPressed), for: .touchUpInside)
        button.tintColor = .orange
        return button
    }()
    
    private var borderLayer: CAShapeLayer?
    
    required init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .background
        self.addSubview(mainStack)
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(detailStack)
        
        detailStack.addArrangedSubview(hoursLabel)
        detailStack.addArrangedSubview(detailsButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        borderLayer?.removeFromSuperlayer()
        borderLayer = self.addRoundedCorners(hasBorder: true)
    }
    
    func updateRestaurant(restaurant: Restaurant) {
        self.restaurant = restaurant
        titleLabel.text = restaurant.name
        hoursLabel.text = restaurant.isOpenString
    }
    
    @objc func detailsButtonPressed() {
        guard let _restaurant = restaurant else { return }
        delegate?.showRestaurantDetail(restaurant: _restaurant)
    }
}
