//
//  ProfileEdit+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/26/23.
//

import UIKit
import SnapKit

extension ProfileEditViewController {
    enum Constant {
        static let maximumNicknameCount: Int = 15
        static let navigationTitle = "프로필 수정"
        static let nicknameTitle = "닉네임"
        static let editButtonTitle = "프로필 수정 완료"
        
        enum Size {
            static let leftPaddingMargin: Int = 12
            static let nicknameTextFieldCornerRadius: CGFloat = 16
            static let profileImageViewSize: CGFloat = 100
            static let imageContainerViewTop: CGFloat = 40
            static let imageContainerViewBottom: CGFloat = 52
            static let profileAddImageViewSize: CGFloat = 32
            static let nicknameTextFieldHeight: CGFloat = 44
            static let editButtonHeight: CGFloat = 52
        }
    }
    
    // MARK: - ViewHolder
    final class ViewHolder: ViewHolderable {
        
        let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(
                mode: .text,
                title: Constant.navigationTitle,
                iconImageKind: nil
            )
            navigationView.favoriteButton.isHidden = true
            navigationView.setText(with: Constant.navigationTitle)
            return navigationView
        }()
        
        let imageContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.makeRounded(with: Constant.Size.profileImageViewSize / 2)
            imageView.makeBorder(width: 1, color: UIColor.gray300.cgColor)
            imageView.setImage(.tagStore)
            return imageView
        }()
        
        let profileAddImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray400
            imageView.setImage(.profilePlus)
            return imageView
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            return stackView
        }()
        
        private let nicknameStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            return stackView
        }()
        
        private let nicknameLabel: UILabel = {
            let label = UILabel()
            label.text = Constant.nicknameTitle
            label.textColor = .gray700
            label.font = .body2m
            return label
        }()
        
        let nicknameCountLabel: UILabel = {
            let label = UILabel()
            label.text = "0/\(Constant.maximumNicknameCount)"
            label.textColor = .gray600
            label.font = .body3r
            return label
        }()
        
        let nicknameTextField: UITextField = {
            let textField = UITextField()
            textField.backgroundColor = .gray100
            textField.addLeftPaddingView(point: Constant.Size.leftPaddingMargin)
            textField.makeRounded(with: Constant.Size.nicknameTextFieldCornerRadius)
            textField.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            return textField
        }()
        
        let nicknameValidateLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .right
            label.font = .body3r
            return label
        }()
        
        let editButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Constant.editButtonTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(imageContainerView)
            imageContainerView.addSubview(profileImageView)
            imageContainerView.addSubview(profileAddImageView)
            
            view.addSubview(stackView)
            stackView.addArrangedSubview(nicknameStackView)
            nicknameStackView.addArrangedSubview(nicknameLabel)
            nicknameStackView.addArrangedSubview(nicknameCountLabel)
            nicknameCountLabel.snp.contentHuggingHorizontalPriority = 1000
            
            stackView.addArrangedSubview(nicknameTextField)
            stackView.addArrangedSubview(nicknameValidateLabel)
            view.addSubview(editButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            imageContainerView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom).offset(Constant.Size.imageContainerViewTop)
                $0.centerX.equalToSuperview()
            }
            
            profileImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.size.equalTo(Constant.Size.profileImageViewSize)
            }
            
            profileAddImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(5)
                $0.bottom.equalToSuperview().offset(3)
                $0.size.equalTo(Constant.Size.profileAddImageViewSize)
            }
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(imageContainerView.snp.bottom).offset(Constant.Size.imageContainerViewBottom)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
            }
            
            nicknameTextField.snp.makeConstraints {
                $0.height.equalTo(Constant.Size.nicknameTextFieldHeight)
            }
            
            editButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constant.Size.editButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview().inset(.spacing16).priority(.low)
            }
        }
    }
}
