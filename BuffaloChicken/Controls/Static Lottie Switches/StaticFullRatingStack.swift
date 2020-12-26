//
//  FullRatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 12/14/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class StaticFullRatingStack: UIStackView {
    private lazy var chickenRatingStack: StaticRatingStack = {
        let stack = StaticRatingStack(switchType: .chicken)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var spiceRatingStack: StaticRatingStack = {
        let stack = StaticRatingStack(switchType: .spice)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sauceRatingStack: StaticRatingStack = {
        let stack = StaticRatingStack(switchType: .sauce)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var friesRatingStack: StaticRatingStack = {
        let stack = StaticRatingStack(switchType: .sides)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var buttonBorder: CAShapeLayer?
    
    required init() {
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.spacing = 5
        
        self.addArrangedSubview(chickenRatingStack)
        self.addArrangedSubview(spiceRatingStack)
        self.addArrangedSubview(sauceRatingStack)
        self.addArrangedSubview(friesRatingStack)
        self.addArrangedSubview(spacer)
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
    }
}
