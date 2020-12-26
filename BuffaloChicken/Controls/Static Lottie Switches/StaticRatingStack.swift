//
//  RatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 11/29/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class StaticRatingStack: UIStackView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .secondary
        return label
    }()
    
    private lazy var lottieSwitches: [StaticLottieSwitch] = []
    private lazy var size:CGFloat = 22.5
    
    required init(switchType: SwitchType) {
        super.init(frame: .zero)
        
        switch switchType {
        case .chicken:
            label.text = "Wings"
        case .spice:
            label.text = "Spice"
        case .sauce:
            label.text = "Sauce"
        case .sides:
            label.text = "Sides"
        }
        
        self.addArrangedSubview(label)
        
        for _ in 0..<5 {
            let lottieSwitch = StaticLottieSwitch(switchType: switchType)
            self.addArrangedSubview(lottieSwitch)
            lottieSwitches.append(lottieSwitch)
        }
        
        self.spacing = 5
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        for lottieSwitch in lottieSwitches {
            lottieSwitch.heightAnchor.constraint(lessThanOrEqualToConstant: size).isActive = true
            lottieSwitch.widthAnchor.constraint(lessThanOrEqualToConstant: size).isActive = true
        }
        
        label.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setEnabled(countEnabled: Int = 0) {
        var count = countEnabled
        for lottieSwitch in lottieSwitches {
            if count > 0 {
                lottieSwitch.setSwitch(isOn: true)
                count -= 1
            } else {
                lottieSwitch.setSwitch(isOn: false)
            }
        }
    }
}
