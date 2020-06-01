//
//  LoadingView.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/15/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
    @IBOutlet weak var stack: UIStackView!
    
    let fadeDuration = 0.5
    
    var lottieView: AnimationView {
        let animation = AnimationView()
        animation.animation = Animation.named("loading-tenders")
        animation.loopMode = .loop
        animation.play()
        return animation
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stack.insertArrangedSubview(lottieView, at: 0)
    }
    
    func show() {
        UIView.animate(withDuration: fadeDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }) { (isCompleted) in
            self.isHidden = false
        }
    }
    
    func hide(delay: Double = 0.0) {
        UIView.animate(withDuration: fadeDuration, delay: delay, options: .curveEaseInOut, animations: {
            self.alpha = 0.25
        }) { (isCompleted) in
            self.isHidden = true
        }
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
