//
//  LottieButton.swift
//  LottieButton
//
//  Created by Sam Doggett on 4/21/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

enum SwitchType {
    case chicken
    case fries
    case sauce
    case spice
}

protocol LottieSwitchDelegate {
    func flipSwitch(sender: LottieSwitch, isOn: Bool)
}

class LottieSwitch: UIButton {
    private lazy var lottieSwitch: AnimatedSwitch = {
        let view = AnimatedSwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(switchFlipped), for: .touchUpInside)
        return view
    }()
    
    private var delegate: LottieSwitchDelegate?
    
    required init(switchType: SwitchType, delegate: LottieSwitchDelegate? = nil, playbackSpeed: CGFloat = 1) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        lottieSwitch.animationSpeed = playbackSpeed
        
        lottieSwitch.setProgressForState(fromProgress: 0.0, toProgress: 0.90, forOnState: true)
        lottieSwitch.setProgressForState(fromProgress: 1.0, toProgress: 1.0, forOnState: false)

        switch switchType {
        case .chicken:
            lottieSwitch.animation = Animation.named("chicken-icon")
        case .fries:
            lottieSwitch.animation = Animation.named("fries-icon")
        case .sauce:
            lottieSwitch.animation = Animation.named("sauce-icon")
        case .spice:
            lottieSwitch.animation = Animation.named("spice-icon")
        }
        
        self.addSubview(lottieSwitch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lottieSwitch.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lottieSwitch.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lottieSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lottieSwitch.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    func setSwitch(isOn: Bool) {
        lottieSwitch.setIsOn(isOn, animated: true)
    }
    
    @objc func switchFlipped() {
        delegate?.flipSwitch(sender: self, isOn: lottieSwitch.isOn)
    }
}
