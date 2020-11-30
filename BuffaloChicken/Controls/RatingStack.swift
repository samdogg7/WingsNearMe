//
//  RatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 11/29/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class RatingStack: UIStackView, LottieSwitchDelegate {
    required init(switchType: SwitchType) {
        super.init(frame: .zero)
        
        self.distribution = .fillEqually
        self.spacing = 10
        
        self.addArrangedSubview(LottieSwitch(switchType: switchType, delegate: self))
        self.addArrangedSubview(LottieSwitch(switchType: switchType, delegate: self))
        self.addArrangedSubview(LottieSwitch(switchType: switchType, delegate: self))
        self.addArrangedSubview(LottieSwitch(switchType: switchType, delegate: self))
        self.addArrangedSubview(LottieSwitch(switchType: switchType, delegate: self))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipSwitch(sender: LottieSwitch, isOn: Bool) {
        for subview in arrangedSubviews {
            if let ratingSwitch = subview as? LottieSwitch {
                if ratingSwitch == sender {
                    return
                }
                ratingSwitch.setSwitch(isOn: isOn)
            }
        }
    }
}
