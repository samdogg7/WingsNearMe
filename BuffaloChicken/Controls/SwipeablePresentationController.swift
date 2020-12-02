//
//  SlidablePresentationController.swift
//  BuffaloChicken
//
//  Inspired by Sarin Swift on 12/1/20.
//  See tutorial here: https://medium.com/@sarinyaswift/pangesture-slidable-view-swift-5-6718517f94a8
//

import UIKit

class SwipeablePresentationController: UIPresentationController {
    // MARK: Properties
    private lazy var blurEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.isUserInteractionEnabled = true
        effectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        return effectView
    }()
    
    private var previousBorderLayer: CAShapeLayer?
    private var desiredTopAnchor: NSLayoutYAxisAnchor
    var translationConstraint: NSLayoutConstraint?

    required init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, desiredTopAnchor: NSLayoutYAxisAnchor) {
        self.desiredTopAnchor = desiredTopAnchor
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedView?.translatesAutoresizingMaskIntoConstraints = false
        translationConstraint = presentedView?.topAnchor.constraint(equalTo: desiredTopAnchor)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(blurEffectView)
        self.blurEffectView.alpha = 0
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.6
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        guard let containerView = containerView  else { return }

        previousBorderLayer?.removeFromSuperlayer()
        previousBorderLayer = presentedView?.addRoundedCorners(radius: 20, corners: [.topLeft, .topRight], borderWidth: 1, borderColor: .lightGray)
        
        translationConstraint?.isActive = true

        presentedView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        presentedView?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        presentedView?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        blurEffectView.topAnchor.constraint(equalTo: presentingViewController.view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
