//
//  LottieButton.swift
//  LottieButton
//
//  Created by Sam Doggett on 4/21/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

class LottieSwitch: UIButton {
    private lazy var lottieView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var animation: Animation?
    private var keyPaths: AnimationKeypath?
    private var playbackSpeed: CGFloat = 1
    private var animated:Bool = true
    private var frameSize: CGFloat = 50.0
    
    required init(frame: CGRect?, animation: Animation, colorKeypaths: AnimationKeypath, playbackSpeed: CGFloat = 1, animated:Bool = true) {
        if let frame = frame {
            super.init(frame: frame)
        } else {
            super.init(frame: .init(x: 0, y: 0, width: frameSize, height: frameSize))
        }
        
        self.animation = animation
        self.keyPaths = colorKeypaths
        self.playbackSpeed = playbackSpeed
        self.animated = animated
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if(animated) {
            if(isSelected) {
                playAnimation(from: 0.5, to: 1.0)
            } else {
                playAnimation(from: 0.0, to: 0.5)
            }
        } else {
            if(isSelected) {
                lottieView.currentProgress = 0.0
            } else {
                lottieView.currentProgress = 0.5
            }
        }
        isSelected = !isSelected
        
        super.sendAction(action, to: target, for: event)
    }
    
    func playAnimation(from: CGFloat, to: CGFloat){
        lottieView.play(fromProgress: from, toProgress: to)
    }
    
    func flipSwitch() {
        if(animated) {
            if(isSelected) {
                playAnimation(from: 0.5, to: 1.0)
            } else {
                playAnimation(from: 0.0, to: 0.5)
            }
        } else {
            if(isSelected) {
                lottieView.currentProgress = 0.0
            } else {
                lottieView.currentProgress = 0.5
            }
        }
        isSelected = !isSelected
    }
    
    //Set the state of the checkbox without user interaction
    public func setOn(isOn: Bool){
        if(isOn) {
            isSelected = true
            lottieView.currentProgress = 0.5
        } else {
            isSelected = false
            lottieView.currentProgress = 0
        }
    }
    
    func setup() {
        self.addSubview(lottieView)

        self.lottieView.animation = animation
        self.lottieView.animationSpeed = playbackSpeed
        
        lottieView.loopMode = .playOnce
        
        if keyPaths != nil {
            updateColorPaths()
        }
    }
    
    func updateColorPaths(){
        if let paths = keyPaths {
            lottieView.setValueProvider(ColorValueProvider(UIColor.inverse.lottieColorValue), keypath: paths)
        }
    }
}
