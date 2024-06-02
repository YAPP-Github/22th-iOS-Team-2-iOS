//
//  MyReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewRouting: ViewableRouting {
    func attachMyDetailReview(productDetail: ProductDetailEntity, review: ReviewEntity)
    func detachMyDetailReview()
}

protocol MyReviewPresentable: Presentable {
    var listener: MyReviewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyReviewListener: AnyObject {
    func detachMyReview()
}

final class MyReviewInteractor: PresentableInteractor<MyReviewPresentable>, MyReviewInteractable, MyReviewPresentableListener {

    weak var router: MyReviewRouting?
    weak var listener: MyReviewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MyReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapMyDetailReview(with productDetail: ProductDetailEntity, reviewId: String) {
        // TODO: 받아온 값으로 수정
//        guard let review = productDetail.reviews.first(where: { $0.reviewId == reviewId }) else { return }
        router?.attachMyDetailReview(productDetail: productDetail, review: .init(reviewId: "", taste: .good, quality: .bad, valueForMoney: .normal, score: 0, contents: "설명입니다 설명입니다 설명입니다 설명입니다 설명입니다 설명입니다설명입니다 설명입니다 설명입니다", image: nil, writerId: nil, writerName: "양볼 빵빵 다람쥐", createdTime: "", updatedTime: "", likeCount: .init(writerIds: [], likeCount: 0), hateCount: .init(writerIds: [], hateCount: 0)))
    }
    
    func didTapBackButton() {
        router?.detachMyDetailReview()
    }
    
    func didTapMyReviewBackButton() {
        listener?.detachMyReview()
    }
}
