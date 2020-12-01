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

class LottieSwitch: UIView {
    private lazy var lottieSwitch: AnimatedSwitch = {
        let view = AnimatedSwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(switchFlipped), for: .touchUpInside)
        return view
    }()
    
    private lazy var lottieView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var touchEnabled = true
    private var delegate: LottieSwitchDelegate?
    
    required init(switchType: SwitchType, touchEnabled: Bool = true, delegate: LottieSwitchDelegate? = nil, playbackSpeed: CGFloat = 1, scale: CGFloat = 1) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.touchEnabled = touchEnabled
        self.setContentHuggingPriority(UILayoutPriority(50), for: .vertical)
        
        if touchEnabled {
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
            
            lottieSwitch.animationSpeed = playbackSpeed
            
            lottieSwitch.setProgressForState(fromProgress: 0.0, toProgress: 0.90, forOnState: true)
            lottieSwitch.setProgressForState(fromProgress: 1.0, toProgress: 1.0, forOnState: false)
            
            self.addSubview(lottieSwitch)
        } else {
            switch switchType {
            case .chicken:
                lottieView.animation = Animation.named("chicken-icon")
            case .fries:
                lottieView.animation = Animation.named("fries-icon")
            case .sauce:
                lottieView.animation = Animation.named("sauce-icon")
            case .spice:
                lottieView.animation = Animation.named("spice-icon")
            }
            
            lottieView.currentFrame = lottieView.animation?.endFrame ?? 0
            
            self.addSubview(lottieView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if touchEnabled {
            lottieSwitch.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lottieSwitch.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lottieSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lottieSwitch.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        } else {
            lottieView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lottieView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lottieView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lottieView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        }
    }
    
    func setSwitch(isOn: Bool) {
        if touchEnabled {
            lottieSwitch.setIsOn(isOn, animated: true)
        } else {
            if isOn {
                lottieView.currentProgress = 0.95
            } else {
                lottieView.currentProgress = 1.0
            }
        }
    }
    
    @objc func switchFlipped() {
        delegate?.flipSwitch(sender: self, isOn: lottieSwitch.isOn)
    }
}
