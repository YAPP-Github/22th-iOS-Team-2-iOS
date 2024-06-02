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
    func update(with productDetail: ProductDetailEntity, review: ReviewEntity)
}

protocol MyDetailReviewListener: AnyObject {
    func didTapBackButton()
}

final class MyDetailReviewInteractor: PresentableInteractor<MyDetailReviewPresentable>, MyDetailReviewInteractable, MyDetailReviewPresentableListener {

    weak var router: MyDetailReviewRouting?
    weak var listener: MyDetailReviewListener?
    private let component: MyDetailReviewComponent
    
    init(
        presenter: MyDetailReviewPresentable,
        component: MyDetailReviewComponent
    ) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.update(with: component.productDetail, review: component.review)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
