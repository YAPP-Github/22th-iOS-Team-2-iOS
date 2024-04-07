//
//  DetailReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs

protocol DetailReviewInteractable: Interactable, ReviewPopupListener {
    var router: DetailReviewRouting? { get set }
    var listener: DetailReviewListener? { get set }
}

protocol DetailReviewViewControllable: ViewControllable {
}

final class DetailReviewRouter: ViewableRouter<DetailReviewInteractable,
                                DetailReviewViewControllable>,
                                DetailReviewRouting {

    private let reviewPopupBuildable: ReviewPopupBuildable
    private var reviewPopupRouting: ReviewPopupRouting?
    
    init(
        interactor: DetailReviewInteractable,
        viewController: DetailReviewViewControllable,
        reviewPopupBuildable: ReviewPopupBuilder
    ) {
        self.reviewPopupBuildable = reviewPopupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPopup(isApply: Bool) {
        guard reviewPopupRouting == nil else { return }
        
        let reviewPopupRouter = reviewPopupBuildable.build(
            withListener: interactor,
            isApply: isApply
        )
        reviewPopupRouting = reviewPopupRouter
        attachChild(reviewPopupRouter)
        let reviewPopup = reviewPopupRouter.viewControllable.uiviewController
        reviewPopup.modalPresentationStyle = .overFullScreen
        viewController.uiviewController.present(reviewPopup, animated: false)
    }
    
    func detachPopup() {
        guard let reviewPopupRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        self.reviewPopupRouting = nil
        detachChild(reviewPopupRouting)
    }
}
