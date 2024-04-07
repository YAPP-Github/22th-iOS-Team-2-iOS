//
//  BottomSheetDismissAnimator.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

class BottomSheetDismissAnimator: NSObject {
    let animateDuration: CGFloat
    
    required init(with duration: CGFloat = 0.2) {
        self.animateDuration = duration
    }
}

extension BottomSheetDismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // fromViewController is presented view controller
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        let estimatedHeight = transitionContext.finalFrame(for: fromViewController).height
        
        UIView.animate(
            withDuration: animateDuration,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                containerView.alpha = 0.0
                fromViewController.view.transform = CGAffineTransform(translationX: 0.0, y: estimatedHeight / 2.0)
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
