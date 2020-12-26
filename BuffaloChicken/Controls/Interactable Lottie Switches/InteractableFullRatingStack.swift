//
//  FullRatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 12/14/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

protocol InteractableFullRatingStackDelegate {
    func reviewSubmit()
}

class InteractableFullRatingStack: UIStackView {
    private var delegate: InteractableFullRatingStackDelegate

    private lazy var chickenRatingStack: InteractableRatingStack = {
        let stack = InteractableRatingStack(switchType: .chicken)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var spiceRatingStack: InteractableRatingStack = {
        let stack = InteractableRatingStack(switchType: .spice)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sauceRatingStack: InteractableRatingStack = {
        let stack = InteractableRatingStack(switchType: .sauce)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var friesRatingStack: InteractableRatingStack = {
        let stack = InteractableRatingStack(switchType: .sides)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        return button
    }()
    
    private var buttonBorder: CAShapeLayer?
    
    required init(delegate: InteractableFullRatingStackDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.spacing = 5
        
        self.addArrangedSubview(chickenRatingStack)
        self.addArrangedSubview(spiceRatingStack)
        self.addArrangedSubview(sauceRatingStack)
        self.addArrangedSubview(friesRatingStack)
        self.addArrangedSubview(submitButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStackEnabled(stackType: SwitchType, countEnabled: Int) {
        switch stackType {
        
        case .chicken:
            chickenRatingStack.setEnabled(countEnabled: countEnabled)
        case .sides:
            friesRatingStack.setEnabled(countEnabled: countEnabled)
        case .sauce:
            sauceRatingStack.setEnabled(countEnabled: countEnabled)
        case .spice:
            spiceRatingStack.setEnabled(countEnabled: countEnabled)
        }
        
        submitButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func getReviews() -> UserReview {
        return UserReview(wingRating: chickenRatingStack.selectedRating, spiceRating: spiceRatingStack.selectedRating, sauceRating: sauceRatingStack.selectedRating, sidesRating: friesRatingStack.selectedRating, review: "")
    }
    
    @objc func submitPressed() {
        delegate.reviewSubmit()
    }
}
