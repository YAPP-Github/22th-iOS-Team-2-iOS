//
//  LoggedOutViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import FirebaseAnalytics
import KakaoSDKUser
import UIKit
import ModernRIBs
import AuthenticationServices

protocol LoggedOutPresentableListener: AnyObject {
    func didTapAppleLoginButton()
    func requestKakaoLogin()
    func requestGuestLogin()
    func dismissLoggedOut()
}

final class LoggedOutViewController:
    UIViewController,
    LoggedOutPresentable,
    LoggedOutViewControllable {

    // MARK: - Interface
    weak var listener: LoggedOutPresentableListener?
    private let viewHolder: ViewHolder = .init()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)

        configureUI()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "social_login"
        ])
    }

    func setLoginView(with isFirstLogin: Bool) {
        if isFirstLogin {
            viewHolder.closeButton.isHidden = true
            viewHolder.guestLoginButton.isHidden = false
        } else {
            viewHolder.closeButton.isHidden = false
            viewHolder.guestLoginButton.isHidden = true
        }
    }

    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }

    private func configureAction() {
        viewHolder.appleLoginButton.addTarget(
            self,
            action: #selector(didTapAppleLoginButton),
            for: .touchUpInside)

        viewHolder.kakaoLoginButton.addTarget(
            self,
            action: #selector(didTapKakaoLoginButton),
            for: .touchUpInside
        )
        viewHolder.guestLoginButton.addTarget(
            self,
            action: #selector(didTapGuestLoginButton),
            for: .touchUpInside
        )
        viewHolder.closeButton.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
    }

    @objc
    private func didTapAppleLoginButton() {
        listener?.didTapAppleLoginButton()
    }

    @objc
    private func didTapKakaoLoginButton() {
        listener?.requestKakaoLogin()
    }
    
    @objc
    private func didTapGuestLoginButton() {
        listener?.requestGuestLogin()
    }
    
    @objc
    private func didTapCloseButton() {
        listener?.dismissLoggedOut()
    }

}
