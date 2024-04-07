//
//  ReviewPopupInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol ReviewPopupRouting: ViewableRouting {
}

protocol ReviewPopupPresentable: Presentable {
    var listener: ReviewPopupPresentableListener? { get set }
}

protocol ReviewPopupListener: AnyObject {
    func popupDidTapDismissButton()
    func popupDidTapBackButton()
    func routeToProductDetail()
}

final class ReviewPopupInteractor: PresentableInteractor<ReviewPopupPresentable>,
                                   ReviewPopupInteractable,
                                   ReviewPopupPresentableListener {

    weak var router: ReviewPopupRouting?
    weak var listener: ReviewPopupListener?

    override init(presenter: ReviewPopupPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapApplyButton() {
        listener?.routeToProductDetail()
    }
    
    func didTapDismissButton() {
        listener?.popupDidTapDismissButton()
    }
    
    func didTapBackButton() {
        listener?.popupDidTapBackButton()
    }
}
