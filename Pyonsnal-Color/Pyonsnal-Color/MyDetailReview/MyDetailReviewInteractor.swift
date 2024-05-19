//
//  MyDetailReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import ModernRIBs

protocol MyDetailReviewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyDetailReviewPresentable: Presentable {
    var listener: MyDetailReviewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyDetailReviewListener: AnyObject {
    func didTapBackButton()
}

final class MyDetailReviewInteractor: PresentableInteractor<MyDetailReviewPresentable>, MyDetailReviewInteractable, MyDetailReviewPresentableListener {

    weak var router: MyDetailReviewRouting?
    weak var listener: MyDetailReviewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MyDetailReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
