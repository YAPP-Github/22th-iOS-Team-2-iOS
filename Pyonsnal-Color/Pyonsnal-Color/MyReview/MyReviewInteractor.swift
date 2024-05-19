//
//  MyReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyReviewRouting: ViewableRouting {
    func attachMyDetailReview()
    func detachMyDetailReview()
}

protocol MyReviewPresentable: Presentable {
    var listener: MyReviewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyReviewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
    
    func didTapMyDetailReview(with reviewId: String) {
        router?.attachMyDetailReview()
    }
    
    func didTapBackButton() {
        router?.detachMyDetailReview()
    }
}
