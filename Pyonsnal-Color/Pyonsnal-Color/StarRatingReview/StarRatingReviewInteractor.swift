//
//  StarRatingReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewRouting: ViewableRouting {
    func attachDetailReview(productDetail: ProductDetailEntity, score: Int)
    func detachDetailReview(animated: Bool)
    func attachPopup(isApply: Bool)
    func detachPopup()
}

protocol StarRatingReviewPresentable: Presentable {
    var listener: StarRatingReviewPresentableListener? { get set }
}

protocol StarRatingReviewListener: AnyObject {
    func detachStarRatingReview()
}

final class StarRatingReviewInteractor: PresentableInteractor<StarRatingReviewPresentable>,
                                        StarRatingReviewInteractable,
                                        StarRatingReviewPresentableListener {

    weak var router: StarRatingReviewRouting?
    weak var listener: StarRatingReviewListener?
    
    private let productDetail: ProductDetailEntity

    init(presenter: StarRatingReviewPresentable, productDetail: ProductDetailEntity) {
        self.productDetail = productDetail
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapRatingButton(score: Int) {
        router?.attachDetailReview(productDetail: productDetail, score: score)
    }
    
    func detachDetailReview() {
        router?.detachDetailReview(animated: true)
    }
    
    func routeToProductDetail() {
        router?.detachDetailReview(animated: false)
        listener?.detachStarRatingReview()
    }
    
    func didTapBackButton() {
        router?.attachPopup(isApply: false)
    }
    
    func popupDidTapDismissButton() {
        router?.detachPopup()
    }
    
    func popupDidTapBackButton() {
        router?.detachPopup()
        listener?.detachStarRatingReview()
    }
}
