//
//  LottieButton.swift
//  LottieButton
//
//  Created by Sam Doggett on 4/21/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

class AWXCheckbox: UIControl {
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.axis = .horizontal
        view.spacing = 5.0
        return view
    }()
    private lazy var lottieView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .black
        view.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        return view
    }()
    
    //A multiplier of the normal playback speed
    private var playbackSpeed: CGFloat = 2
    private var animated:Bool = true
    private var frameSize: CGFloat = 22.0
    
    required init(text: String? = nil, playbackSpeed: CGFloat = 1, animated:Bool = true, themeClass: String? = nil) {
        super.init(frame: .init(x: 0, y: 0, width: frameSize, height: frameSize))
        
        self.playbackSpeed = playbackSpeed
        self.animated = animated
        self.label.text = text
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.heightAnchor.constraint(equalToConstant: frameSize).isActive = true

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: frameSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let lottieFrame = lottieView.frame
        let stackFrame = stack.frame
                
        if let touch = touches.first {
            if(touch.location(in: self).x <= lottieFrame.maxX && touch.location(in: self).x >= lottieFrame.minX) {
                if(touch.location(in: self).y <= stackFrame.maxY && touch.location(in: self).y >= stackFrame.minY) {
                    if(animated) {
                        if(isSelected) {
                            playAnimation(from: 0.5, to: 0.0)
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
                    super.touchesBegan(touches, with: event)
                }
            }
        }
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
        self.addSubview(stack)
        
        stack.addArrangedSubview(lottieView)
        
        if label.text != nil {
            lottieView.widthAnchor.constraint(equalToConstant: frameSize).isActive = true
            stack.addArrangedSubview(label)
        }
        self.lottieView.backgroundColor = .systemPink
        self.lottieView.animation = Animation.named("fries-icon")
        self.lottieView.animationSpeed = playbackSpeed
        self.lottieView.loopMode = .playOnce
        
//        updateColorPaths()
    }
    
    func setLabelColor(color: UIColor) {
        self.label.textColor = color
//        updateColorPaths()
    }
    
    func setTitle(text: String) {
        if label.text == nil {
            lottieView.widthAnchor.constraint(equalToConstant: frameSize).isActive = true
            stack.addArrangedSubview(label)
        }
        
        label.text = text
    }
    
    //Change the colors of the lottie animation through the keypath of the JSON file
//    func updateColorPaths(){
//        //Find keypaths with lottieView.logHierarchyKeypaths()
//        let filledInColor = UIColor.red
//        let outlineColor = (self.label.textColor ?? UIColor.green)
//        let primaryKeyPath = AnimationKeypath(keypath: "Rectangle.Rectangle.Fill 1.Color")
//        let secondaryKeyPath = AnimationKeypath(keypath: "Rectangle Copy 4.Rectangle Copy 4.Fill 1.Color")
//
//        lottieView.setValueProvider(ColorValueProvider(Color(r: Double(filledInColor.rgba.red), g: Double(filledInColor.rgba.green), b: Double(filledInColor.rgba.blue), a: Double(filledInColor.rgba.alpha))), keypath: primaryKeyPath)
//
//        lottieView.setValueProvider(ColorValueProvider(Color(r: Double(outlineColor.rgba.red), g: Double(outlineColor.rgba.green), b: Double(outlineColor.rgba.blue), a: Double(outlineColor.rgba.alpha))), keypath: secondaryKeyPath)
//    }
    
    func playAnimation(from: CGFloat, to: CGFloat){
        lottieView.play(fromProgress: from, toProgress: to)
    }
}
