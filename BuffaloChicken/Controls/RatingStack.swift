//
//  RatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 11/29/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class RatingStack: UIStackView, LottieSwitchDelegate {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Rating:"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var lottieSwitches: [LottieSwitch] = []
    
    required init(switchType: SwitchType, touchEnabled: Bool, countEnabled: Int = 0) {
        super.init(frame: .zero)
        
        switch switchType {
        case .chicken:
            label.text = "Wings:"
        case .fries:
            label.text = "Sides:"
        case .sauce:
            label.text = "Sauce:"
        case .spice:
            label.text = "Spice:"
        }
        
        self.addArrangedSubview(label)
        self.addArrangedSubview(stack)
        
        var count = countEnabled
        for _ in 0..<5 {
            let lottieSwitch = LottieSwitch(switchType: switchType, touchEnabled: touchEnabled, delegate: self)
            if count > 0 {
                lottieSwitch.setSwitch(isOn: true)
                count -= 1
            }
            stack.addArrangedSubview(lottieSwitch)
            lottieSwitches.append(lottieSwitch)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        for lottieSwitch in lottieSwitches {
            lottieSwitch.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
    
    func flipSwitch(sender: LottieSwitch, isOn: Bool) {
        for subview in stack.arrangedSubviews {
            if let ratingSwitch = subview as? LottieSwitch {
                if ratingSwitch == sender {
                    return
                }
                ratingSwitch.setSwitch(isOn: isOn)
            }
        }
    }
}
