//
//  BottomSheetPresentor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

final class BottomSheetPresentor: NSObject {
    var containerSize: CGSize?
    var backgroundColor: UIColor?
    var backgroundDidTapAction: (() -> Void)? {
        didSet {
//            self.presentationController?.backgground
        }
    }
    
    private var presentationController: BottomSheetPresentationController?
    
    func update() {
        presentationController?.containerViewWillLayoutSubviews()
    }
}

extension BottomSheetPresentor: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = BottomSheetPresentationController(
            containerSize: containerSize,
            presented: presented,
            presenting: presenting,
            backgroundDidTapAction: backgroundDidTapAction,
            dismissCompletion: { [weak self] in
                self?.presentationController = nil
            }
        )
        self.presentationController = presentationController
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if let backgroundColor {
            return BottomToTopPresentAnimator(backgroundColor: backgroundColor)
        } else {
            return BottomSheetDismissAnimator()
        }
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetDismissAnimator()
    }
}
