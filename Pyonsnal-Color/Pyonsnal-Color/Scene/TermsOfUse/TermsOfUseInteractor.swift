//
//  TermsOfUseInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import ModernRIBs

protocol TermsOfUseRouting: ViewableRouting {
    func attachCommonWebView(with terms: SubTerms)
    func detachCommonWebView()
}

protocol TermsOfUsePresentable: Presentable {
    var listener: TermsOfUsePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TermsOfUseListener: AnyObject {
    func termsOfUseCloseButtonDidTap()
    func termsOfUseAcceptButtonDidTap()
}

final class TermsOfUseInteractor: PresentableInteractor<TermsOfUsePresentable>, TermsOfUseInteractable, TermsOfUsePresentableListener {
    

    weak var router: TermsOfUseRouting?
    weak var listener: TermsOfUseListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TermsOfUsePresentable) {
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
    
    func dismissViewController() {
        listener?.termsOfUseCloseButtonDidTap()
    }
    
    func routeToLoggedInIfNeeded() {
        // 로그인 request with 어떤 로그인 버튼 클릭했는지랑
        // 토큰 저장
        listener?.termsOfUseAcceptButtonDidTap()
    }
    
    func routeToWebView(subTermsInfo: SubTerms) {
        router?.attachCommonWebView(with: subTermsInfo)
    }
    
    func detachCommonWebView() {
        router?.detachCommonWebView()
    }
}
