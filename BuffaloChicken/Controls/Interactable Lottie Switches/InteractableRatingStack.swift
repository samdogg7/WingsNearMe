//
//  RatingStack.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 11/29/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class InteractableRatingStack: UIStackView, LottieSwitchDelegate {
    var selectedRating: Int = 0
    
    private lazy var lottieSwitches: [InteractableLottieSwitch] = []
    private lazy var size:CGFloat = 22.5
    
    required init(switchType: SwitchType) {
        super.init(frame: .zero)
        
        for _ in 0..<5 {
            let lottieSwitch = InteractableLottieSwitch(switchType: switchType)
            lottieSwitch.delegate = self
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
    }
    
    func flipSwitch(sender: InteractableLottieSwitch, isOn: Bool) {
        selectedRating = 0
        for subview in self.arrangedSubviews {
            if let ratingSwitch = subview as? InteractableLottieSwitch {
                selectedRating += 1
                if ratingSwitch == sender {
                    return
                }
                ratingSwitch.setSwitch(isOn: isOn)
            }
        }
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
        selectedRating = countEnabled
    }
}
