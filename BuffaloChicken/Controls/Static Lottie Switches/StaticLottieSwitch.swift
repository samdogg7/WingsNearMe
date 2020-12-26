//
//  LottieButton.swift
//  LottieButton
//
//  Created by Sam Doggett on 4/21/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

class StaticLottieSwitch: UIView {
    private lazy var lottieView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init(switchType: SwitchType, scale: CGFloat = 1) {
        super.init(frame: .zero)
                
        switch switchType {
        case .chicken:
            lottieView.animation = Animation.named("chicken-icon")
        case .sides:
            lottieView.animation = Animation.named("fries-icon")
        case .sauce:
            lottieView.animation = Animation.named("sauce-icon")
        case .spice:
            lottieView.animation = Animation.named("spice-icon")
        }
        
        lottieView.currentFrame = lottieView.animation?.endFrame ?? 0
        
        self.addSubview(lottieView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lottieView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lottieView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lottieView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lottieView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    func setSwitch(isOn: Bool) {
        if isOn {
            lottieView.currentProgress = 0.95
        } else {
            lottieView.currentProgress = 1.0
        }
    }
}
