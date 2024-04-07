//
//  LogoutPopupInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs
import Combine

protocol LogoutPopupRouting: ViewableRouting {
    
}

protocol LogoutPopupPresentable: Presentable {
    var listener: LogoutPopupPresentableListener? { get set }
}

protocol LogoutPopupListener: AnyObject {
    func popupDidTabDismissButton()
    func routeToLoggedOut()
}

final class LogoutPopupInteractor:
    PresentableInteractor<LogoutPopupPresentable>,
    LogoutPopupInteractable,
    LogoutPopupPresentableListener {

    enum Text {
        static let dismiss: String = "취소하기"
    }

    weak var router: LogoutPopupRouting?
    weak var listener: LogoutPopupListener?
    
    private let component: LogoutPopupComponent
    private var cancellable = Set<AnyCancellable>()
    
    init(presenter: LogoutPopupPresentable, component: LogoutPopupComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapDismissButton() {
        listener?.popupDidTabDismissButton()
    }
    
    func didTapLogoutButton() {
        logout()
    }
    
    func didTapDeleteAccountButton() {
        deleteAccount()
    }
    
    private func logout() {
        guard let accessToken = component.userAuthService.getAccessToken(), let refreshToken = component.userAuthService.getRefreshToken() else { return }
        component.memberAPIService.logout(
            accessToken: accessToken,
            refreshToken: refreshToken
        ).sink { [weak self] response in
            // 응답이 null로 옴
            if response.error?.type == .emptyResponse {
                self?.deleteToken()
                self?.listener?.routeToLoggedOut()
            }else {
                // Error handling
            }
        }.store(in: &cancellable)
    }
    
    private func deleteAccount() {
        let accessToken = component.userAuthService.getAccessToken()
        component.memberAPIService.widthraw()
            .sink { [weak self] response in
                //응답이 null로 옴
                if response.error?.type == .emptyResponse {
                    self?.deleteToken()
                    self?.listener?.routeToLoggedOut()
                }else {
                    // Error handling
                }
            }.store(in: &cancellable)
    }
    
    private func deleteToken() {
        component.userAuthService.deleteAccessToken()
        component.userAuthService.deleteRefreshToken()
    }
    
}
