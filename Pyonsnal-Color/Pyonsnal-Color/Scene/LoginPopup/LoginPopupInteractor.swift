//
//  LoginPopupInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import ModernRIBs

protocol LoginPopupRouting: ViewableRouting {
}

protocol LoginPopupPresentable: Presentable {
    var listener: LoginPopupPresentableListener? { get set }
}

protocol LoginPopupListener: AnyObject {
    func popupDidTapDismiss()
    func popupDidTapConfirm()
}

final class LoginPopupInteractor: PresentableInteractor<LoginPopupPresentable>, 
                                  LoginPopupInteractable,
                                  LoginPopupPresentableListener {

    weak var router: LoginPopupRouting?
    weak var listener: LoginPopupListener?

    override init(presenter: LoginPopupPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func popupDidTapDismiss() {
        listener?.popupDidTapDismiss()
    }
    
    func popupDidTapConfirm() {
        listener?.popupDidTapConfirm()
    }
}
