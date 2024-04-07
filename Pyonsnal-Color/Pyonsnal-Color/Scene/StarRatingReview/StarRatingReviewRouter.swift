//
//  StarRatingReviewRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import ModernRIBs

protocol StarRatingReviewInteractable: Interactable, DetailReviewListener, ReviewPopupListener {
    var router: StarRatingReviewRouting? { get set }
    var listener: StarRatingReviewListener? { get set }
}

protocol StarRatingReviewViewControllable: ViewControllable {
}

final class StarRatingReviewRouter: ViewableRouter<StarRatingReviewInteractable,
                                    StarRatingReviewViewControllable>,
                                    StarRatingReviewRouting {
    
    private let detailReviewBuilder: DetailReviewBuildable
    private var detailReviewRouting: DetailReviewRouting?
    
    private let reviewPopupBuilder: ReviewPopupBuildable
    private var reviewPopupRouting: ReviewPopupRouting?

    init(
        interactor: StarRatingReviewInteractable,
        viewController: StarRatingReviewViewControllable,
        detailReviewBuilder: DetailReviewBuildable,
        reviewPopupBuilder: ReviewPopupBuildable
    ) {
        self.detailReviewBuilder = detailReviewBuilder
        self.reviewPopupBuilder = reviewPopupBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachDetailReview(
        productDetail: ProductDetailEntity,
        score: Int,
        userReviewInput: UserReviewInput
    ) {
        guard detailReviewRouting == nil else { return }
        
        let detailReviewRouter = detailReviewBuilder.build(
            withListener: interactor,
            productDetail: productDetail,
            score: score,
            userReviewInput: userReviewInput
        )
        detailReviewRouting = detailReviewRouter
        attachChild(detailReviewRouter)
        viewController.pushViewController(detailReviewRouter.viewControllable, animated: true)
    }
    
    func detachDetailReview(animated: Bool) {
        guard let detailReviewRouting else { return }
        
        viewController.popViewController(animated: animated)
        self.detailReviewRouting = nil
        detachChild(detailReviewRouting)
    }
    
    func attachPopup(isApply: Bool) {
        guard reviewPopupRouting == nil else { return }
        
        let reviewPopupRouter = reviewPopupBuilder.build(
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
