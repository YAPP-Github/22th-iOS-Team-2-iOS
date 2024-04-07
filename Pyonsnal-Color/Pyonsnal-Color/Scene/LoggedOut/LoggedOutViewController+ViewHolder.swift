//
//  LoggedOutViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/10.
//

import UIKit
import SnapKit
import Lottie

extension LoggedOutViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Constant {
            enum Size {
                static let logoImageViewHeight: CGFloat = 46
                static let logoImageViewTopOffset: CGFloat = 80
                static let descriptionLabelBottom: CGFloat = 60
                static let loginButtonCornerRadius: CGFloat = 16
                static let loginSize: CGFloat = 250
                static let loginStackViewTop: CGFloat = 102
                static let loginStackViewBottomInset: CGFloat = 15
                static let loginStackViewSpacing: CGFloat = 8
                static let loginButtonHeight: CGFloat = 52
                static let closeButtonSize: CGFloat = 48
            }
            
            enum Text {
                static let guestLoginButtonText: String = "로그인 없이 둘러보기"
                static let descriptionText: String = "나에게 딱 맞는 편의점 상품 정보"
            }
        }
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let graphicContentLayoutView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let graphicContentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let loginImageView: LottieAnimationView = {
            let animation = LottieAnimation.named("login")
            let animationView = LottieAnimationView(animation: animation)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            return animationView
        }()

        private let logoImageView: UIImageView = {
            let imageView: UIImageView = .init(frame: .zero)
            imageView.setImage(.iconPyonsnalColor)
            return imageView
        }()

        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .body1m
            label.textColor = .gray500
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = Constant.Text.descriptionText
            return label
        }()

        private let loginButtonStackView: UIStackView = {
            let stackView: UIStackView = .init(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = Constant.Size.loginStackViewSpacing
            return stackView
        }()

        let kakaoLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginKakao, for: .normal)
            button.layer.cornerRadius = Constant.Size.loginButtonCornerRadius
            return button
        }()

        let appleLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginApple, for: .normal)
            button.layer.cornerRadius = Constant.Size.loginButtonCornerRadius
            return button
        }()

        let guestLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setTitle(Constant.Text.guestLoginButtonText, for: .normal)
            button.setTitleColor(.gray500, for: .normal)
            button.titleLabel?.font = .body2m
            button.backgroundColor = .white
            button.layer.cornerRadius = Constant.Size.loginButtonCornerRadius
            return button
        }()
        
        let closeButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.iconClose, for: .normal)
            return button
        }()
        
        // MAKR: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)

            contentView.addSubview(graphicContentLayoutView)
            contentView.addSubview(loginButtonStackView)
            contentView.addSubview(closeButton)
            
            graphicContentLayoutView.addSubview(graphicContentView)
            
            graphicContentView.addSubview(logoImageView)
            graphicContentView.addSubview(descriptionLabel)
            graphicContentView.addSubview(loginImageView)

            loginButtonStackView.addArrangedSubview(kakaoLoginButton)
            loginButtonStackView.addArrangedSubview(appleLoginButton)
            loginButtonStackView.addArrangedSubview(guestLoginButton)
        }

        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            graphicContentLayoutView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }

            graphicContentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            logoImageView.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.logoImageViewHeight)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }

            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(logoImageView.snp.bottom).offset(.spacing24)
                make.centerX.equalToSuperview()
            }
            
            loginImageView.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.Size.descriptionLabelBottom)
                make.width.equalTo(Constant.Size.loginSize)
                make.height.equalTo(Constant.Size.loginSize)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }

            loginButtonStackView.snp.makeConstraints { make in
                make.top.equalTo(graphicContentLayoutView.snp.bottom)
                make.leading.equalToSuperview().offset(.spacing16)
                make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(.spacing16)
                make.bottom.greaterThanOrEqualToSuperview().inset(.spacing16)
                make.centerX.equalToSuperview()
            }

            kakaoLoginButton.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.loginButtonHeight)
            }

            appleLoginButton.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.loginButtonHeight)
            }
            
            guestLoginButton.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.loginButtonHeight)
            }
            
            closeButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(.spacing4)
                make.size.equalTo(Constant.Size.closeButtonSize)
            }
        }
    }
}
