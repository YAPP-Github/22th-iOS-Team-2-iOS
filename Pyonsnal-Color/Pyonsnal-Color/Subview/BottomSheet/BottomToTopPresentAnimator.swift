//
//  BottomToTopPresentAnimator.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

class BottomToTopPresentAnimator: NSObject {
    let animateDuration: CGFloat
    let backgroundColor: UIColor
    
    required init(
        with duration: CGFloat = 0.2,
        backgroundColor: UIColor = .black.withAlphaComponent(0.8)
    ) {
        self.animateDuration = duration
        self.backgroundColor = backgroundColor
    }
}

extension BottomToTopPresentAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        animateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // toViewcontroller is presented view controller
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let estimatedHeight = transitionContext.finalFrame(for: toViewController).height
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = backgroundColor
        containerView.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        toViewController.view.transform = CGAffineTransform(
            translationX: 0.0, y: estimatedHeight / 2.0
        )
        
        UIView.animate(
            withDuration: animateDuration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                containerView.alpha = 1.0
                toViewController.view.transform = CGAffineTransform.identity
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
