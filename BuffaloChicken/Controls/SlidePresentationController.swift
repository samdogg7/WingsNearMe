//
//  SlidablePresentationController.swift
//  BuffaloChicken
//
//  Inspired by Sarin Swift on 12/1/20.
//  See tutorial here: https://medium.com/@sarinyaswift/pangesture-slidable-view-swift-5-6718517f94a8
//

import UIKit

class SlidePresentationController: UIPresentationController {
    // MARK: Properties
    private lazy var blurEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.isUserInteractionEnabled = true
        effectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        return effectView
    }()
    
    private var previousBorderLayer: CAShapeLayer?
    private var middleAnchor: NSLayoutYAxisAnchor
    private var upperAnchor: NSLayoutYAxisAnchor
    var translationConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?

    required init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, upperAnchor: NSLayoutYAxisAnchor, middleAnchor: NSLayoutYAxisAnchor) {
        self.upperAnchor = upperAnchor
        self.middleAnchor = middleAnchor
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedView?.translatesAutoresizingMaskIntoConstraints = false
        translationConstraint = presentedView?.topAnchor.constraint(equalTo: middleAnchor, constant: 5)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView  else { return }
        containerView.addSubview(blurEffectView)
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
        
        guard let containerView = containerView else { return }

        previousBorderLayer?.removeFromSuperlayer()
        previousBorderLayer = presentedView?.addRoundedCorners(corners: [.topLeft, .topRight], hasBorder: true)
        
        if bottomConstraint == nil {
            bottomConstraint = presentedView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 300)
            bottomConstraint?.isActive = true
        }
        
        translationConstraint?.isActive = true
        
        presentedView?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        presentedView?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        blurEffectView.topAnchor.constraint(equalTo: presentingViewController.view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func dismissController(){
        if let restaurantDetailVC = self.presentedViewController as? RestaurantDetailViewController {
            restaurantDetailVC.dismissTriggered()
        } else {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    enum TopAnchorPosition {
        case upper
        case middle
    }
    
    func updateContainerViewTopAnchor(_ topAnchorPos: TopAnchorPosition) {
        translationConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: {
            switch topAnchorPos {
            case .upper:
                self.translationConstraint = self.presentedView?.topAnchor.constraint(equalTo: self.upperAnchor, constant: 5)
            case .middle:
                self.translationConstraint = self.presentedView?.topAnchor.constraint(equalTo: self.middleAnchor, constant: 5)
            }
            self.translationConstraint?.isActive = true
            
            self.presentedView?.layoutIfNeeded()
        })
    }
}
