//
//  AccountSettingInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingRouting: ViewableRouting {
    func attachPopup(isLogout: Bool)
    func detachPopup()
    func attachCommonWebView(with subTerms: SubTerms)
    func detachCommonWebView()
}

protocol AccountSettingPresentable: Presentable {
    var listener: AccountSettingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AccountSettingListener: AnyObject {
    func didTapBackButton()
    func routeToLoggedOut()
}

final class AccountSettingInteractor: PresentableInteractor<AccountSettingPresentable>, AccountSettingInteractable, AccountSettingPresentableListener {

    weak var router: AccountSettingRouting?
    weak var listener: AccountSettingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AccountSettingPresentable) {
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
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
    
    func didTapLogoutButton() {
        router?.attachPopup(isLogout: true)
    }
    
    func didTapDeleteAccountButton() {
        router?.attachPopup(isLogout: false)
    }
    
    func popupDidTabDismissButton() {
        router?.detachPopup()
    }
    
    func didTapUseSection(with subTerms: SubTerms) {
        router?.attachCommonWebView(with: subTerms)
    }
    
    func detachCommonWebView() {
        router?.detachCommonWebView()
    }
    
    func routeToLoggedOut() {
        listener?.routeToLoggedOut()
    }
    
}
