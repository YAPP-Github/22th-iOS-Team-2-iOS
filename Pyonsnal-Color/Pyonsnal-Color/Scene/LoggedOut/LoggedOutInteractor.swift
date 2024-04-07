//
//  LoggedOutInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs
import Combine
import Foundation

protocol LoggedOutRouting: ViewableRouting {
    func attachTermsOfUse()
    func detachTermsOfUse()
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
    func setLoginView(with isFirstLogin: Bool)
}

protocol LoggedOutListener: AnyObject {
    func routeToLoggedIn()
    func detachLoggedOut()
}

final class LoggedOutInteractor:
    PresentableInteractor<LoggedOutPresentable>,
    LoggedOutInteractable,
    LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private var dependency: LoggedOutDependency
    private var cancellable = Set<AnyCancellable>()
    // Legacy...
    enum LoginTask {
        case apple(identifyToken: String)
        case kakao(accessToken: String)
    }
    private var loginTask: LoginTask?
    
    init(presenter: LoggedOutPresentable, dependency: LoggedOutDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        dependency.appleLoginService.delegate = self
        dependency.kakaoLoginService.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        let isFirstLogin = dependency.userAuthService.getAccessToken() == nil
        presenter.setLoginView(with: isFirstLogin)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapAppleLoginButton() {
        dependency.appleLoginService.requestAppleLogin()
    }
    
    func requestKakaoLogin() {
        dependency.kakaoLoginService.requestKakaoLogin()
    }
    
    func requestGuestLogin() {
        dependency.authClient.guestLogin()
            .sink { [weak self] response in
                if let userAuth = response.value {
                    Log.d(message: "guest login success: \(userAuth)")
                    self?.setUserAuthEntity(userAuth: userAuth)
                    self?.listener?.routeToLoggedIn()
                    UserInfoService.shared.configure()
                }
            }.store(in: &cancellable)
    }
    
    private func requestLogin(with token: String, authType: AuthType) {
        dependency.authClient.login(token: token, authType: authType)
            .sink { [weak self] response in
                if let userAuth = response.value {
                    Log.d(message: "login success: \(userAuth)")
                    self?.setUserAuthEntity(userAuth: userAuth)
                    self?.listener?.routeToLoggedIn()
                    UserInfoService.shared.configure()
                }
            }.store(in: &cancellable)
    }
    
    private func setUserAuthEntity(userAuth: UserAuthEntity) {
        self.dependency.userAuthService.setAccessToken(userAuth.accessToken)
        self.dependency.userAuthService.setRefreshToken(userAuth.refreshToken)
    }
    
    private func resumeLoginProcess() {
        if let loginTask {
            switch loginTask {
            case .apple(let identifyToken):
                requestLogin(with: identifyToken, authType: .apple)
            case .kakao(let accessToken):
                requestLogin(with: accessToken, authType: .kakao)
            }
        }
        loginTask = nil
    }
    
    func termsOfUseCloseButtonDidTap() {
        loginTask = nil
        router?.detachTermsOfUse()
    }
    
    func termsOfUseAcceptButtonDidTap() {
        resumeLoginProcess()
    }
    
    func dismissLoggedOut() {
        listener?.detachLoggedOut()
    }
    
    private func checkLoginStatus(token: String, authType: AuthType) {
        dependency.authClient
            .loginStatus(token: token, authType: authType)
            .sink { [weak self] response in
                if let isJoined = response.value?.isJoined, isJoined {
                    self?.requestLogin(with: token, authType: authType)
                } else {
                    self?.router?.attachTermsOfUse()
                }
            }.store(in: &cancellable)
    }
    
}

extension LoggedOutInteractor: AppleLoginServiceDelegate {
    func didCompleteWithAuthorization(identifyToken: String) {
        loginTask = .apple(identifyToken: identifyToken)
        checkLoginStatus(token: identifyToken, authType: .apple)
    }
}

extension LoggedOutInteractor: KakaoLoginServiceDelegate {
    func didReceive(accessToken: String) {
        loginTask = .kakao(accessToken: accessToken)
        checkLoginStatus(token: accessToken, authType: .kakao)
    }
}
