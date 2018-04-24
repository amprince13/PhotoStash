//
//  SlideInPresentationController.swift
//  PhotoStash
//
//  Created by Glizela Taino on 2/20/18.
//  Copyright © 2018 photostash. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
    
    fileprivate var dimmingView: UIView!
    private var direction: PresentationDirection
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        //1
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        //2
        switch direction {
        case .bottom:
            frame.origin.y = containerView!.frame.height*(7.0/12.0)
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection){
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: {_ in self.dimmingView.alpha = 1.0}, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(5.0/12.0))
        }
    }

}

private extension SlideInPresentationController {
    func setupDimmingView(){
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    //this was added @objc
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
