//
//  TermsOfUseViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/02.
//

import ModernRIBs
import UIKit
import SnapKit

protocol TermsOfUsePresentableListener: AnyObject {
    func dismissViewController()
    func routeToLoggedInIfNeeded()
    func routeToWebView(subTermsInfo: SubTerms)
}

final class TermsOfUseViewController: UIViewController,
                                      TermsOfUsePresentable,
                                      TermsOfUseViewControllable {
    
    enum Constants {
        enum Text {
            static let allAgree = "모두 동의"
            static let acceptButtonTitle = "가입완료"
            static let title = "서비스 이용에 동의해주세요."
        }
        enum Size {
            static let closeButtonSize = 24
            static let popupViewCornerRadius: CGFloat = 16
            static let popupViewHeight: CGFloat = 450
            static let popUpHeaderViewHeight: CGFloat = 68
            static let allAggreeButtonTop: CGFloat = 40
            static let termsButtonHeight: CGFloat = 40
            static let dividerHeight: CGFloat = 1
            static let acceptButtonHeight: CGFloat = 52
        }
    }
    
    
    weak var listener: TermsOfUsePresentableListener?
    
    private let viewHolder: ViewHolder = .init()
    
    static let subTerms: [SubTerms] = [
        SubTerms(title: "(필수) 만 14세 이상입니다.",
                 type: .age),
        SubTerms(title: "(필수) 서비스 이용약관 동의",
                 hasNextPage: true,
                 type: .use),
        SubTerms(title: "(필수) 개인정보 처리방침 동의",
                 hasNextPage: true,
                 type: .privateInfo)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "termofuse"
        ])
    }
    
    func configureAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(didTapBackgroundView))
        viewHolder.backGroundView.addGestureRecognizer(tapGestureRecognizer)
        viewHolder.closeButton.addTarget(self,
                                         action: #selector(didTapCloseButton),
                                         for: .touchUpInside)
        viewHolder.allAgreeButton.addTarget(self,
                                            action: #selector(didTapAllAgreeButton),
                                            for: .touchUpInside)
        viewHolder.acceptButton.addTarget(self,
                                        action: #selector(didTapAcceptButton),
                                        for: .touchUpInside)
        
        for subTermsButton in viewHolder.subTermsButtons {
            subTermsButton.addTarget(self,
                                     action: #selector(didTapTermsButton(_:)),
                                     for: .touchUpInside)
        }
        
        for (index, subTermsArrowButton) in viewHolder.subTermsOfArrowButtons.enumerated() {
            subTermsArrowButton.tag = index
            subTermsArrowButton.addTarget(self,
                                          action: #selector(didTapTermsArrowButton(_:)),
                                          for: .touchUpInside)
        }
            
    }
    
    @objc
    private func didTapBackgroundView() {
        listener?.dismissViewController()
    }
    
    @objc
    private func didTapCloseButton() {
        listener?.dismissViewController()
    }
    
    @objc
    private func didTapAllAgreeButton() {
        let toggledSelected = !viewHolder.allAgreeButton.isCurrentSelected()
        
        //set allAgreeButton
        viewHolder.allAgreeButton.setButtonState(isSelected: toggledSelected)
        
        //set subTermsButtons
        viewHolder.subTermsButtons.forEach { subTermsButton in
            subTermsButton.setButtonState(isSelected: toggledSelected)
        }
        // set acceptButton
        setAcceptButtonState(with: toggledSelected)
    }
    
    @objc
    private func didTapTermsButton(_ sender: TermsButton) {
        let toggledState = !sender.isSelected
        //set subTermsButtons
        sender.setButtonState(isSelected: toggledState)
        
        let isAllSubTermsButtonSelected = viewHolder.subTermsButtons.allSatisfy { $0.isSelected }
        //set allAgreeButton
        viewHolder.allAgreeButton.setButtonState(isSelected: isAllSubTermsButtonSelected)
        
        // set acceptButton
        let allAgreeButtonState = viewHolder.allAgreeButton.isCurrentSelected()
        let acceptButtonState = isAllSubTermsButtonSelected && allAgreeButtonState
        setAcceptButtonState(with: acceptButtonState)
    }
    
    @objc
    private func didTapTermsArrowButton(_ sender: UIButton) {
        let subTerms = TermsOfUseViewController.subTerms[sender.tag]
        listener?.routeToWebView(subTermsInfo: subTerms)
    }
    
    @objc
    private func didTapAcceptButton() {
        listener?.routeToLoggedInIfNeeded()
    }
    
    private func setAcceptButtonState(with isAllSelected: Bool) {
        let buttonEnabled: PrimaryButton.ButtonSelectable = isAllSelected ? .enabled : .disabled
        viewHolder.acceptButton.setState(with: buttonEnabled)
    }
    
}

extension TermsOfUseViewController {
    final class ViewHolder: ViewHolderable {
        var subTermsButtons: [TermsButton] {
            return [subTermsOfAgeButton, subTermsOfUseButton, subTermsOfPrivateInfoButton]
        }
        
        var subTermsOfArrowButtons: [UIButton] {
            return [UIButton(), subTermsOfUseArrowButton, subTermsOfPrivateInfoArrowButton]
        }
        
        let backGroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.layer.opacity = 0.5
            return view
        }()
        
        private let popUpView: UIView = {
            let view = UIView()
            view.makeRoundCorners(cornerRadius: Constants.Size.popupViewCornerRadius,
                                  maskedCorners: [.layerMinXMinYCorner,
                                                  .layerMaxXMinYCorner])
            view.backgroundColor = .white
            return view
        }()
        
        // MARK: popUpHeaderView
        private let popUpHeaderView: UIView = {
            let view = UIView()
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = Constants.Text.title
            label.textColor = .black
            label.font = .title1
            return label
        }()
        
        let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconClose, for: .normal)
            button.tintColor = .gray700
            return button
        }()

        // MARK: allAgreeButton
        let allAgreeButton: TermsButton = {
            let button = TermsButton(textColor: .black,
                                     font: .title2,
                                     isSelected: false)
            button.setText(with: Constants.Text.allAgree)
            return button
        }()
        
        let subButtonVerticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing12
            return stackView
        }()
        
        private let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            return view
        }()
        
        // MARK: subTermsButton
        let subTermsOfAgeButton: TermsButton = {
            let button = TermsButton(textColor: .gray700,
                                     font: .body2r,
                                     isSelected: false)
            return button
        }()
        
        let subTermsOfUseButton: TermsButton = {
            let button = TermsButton(textColor: .gray700,
                                     font: .body2r,
                                     isSelected: false)
            return button
        }()
        
        private let subTermsOfPrivateInfoButton: TermsButton = {
            let button = TermsButton(textColor: .gray700,
                                     font: .body2r,
                                     isSelected: false)
            return button
        }()
        
        private let subTermsOfUseArrowButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconArrow, for: .normal)
            return button
        }()
        
        private let subTermsOfPrivateInfoArrowButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconArrow, for: .normal)
            return button
        }()
        
        // MARK: acceptButton
        let acceptButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Constants.Text.acceptButtonTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backGroundView)
            view.addSubview(popUpView)
            
            popUpView.addSubview(popUpHeaderView)
            popUpView.addSubview(titleLabel)
            popUpView.addSubview(closeButton)
            
            popUpView.addSubview(allAgreeButton)
            popUpView.addSubview(dividerView)
            
            popUpView.addSubview(subButtonVerticalStackView)
            popUpView.addSubview(acceptButton)
            for (index, subTerm) in subTerms.enumerated() {
                
                //매번 생성 필요하여 여기에서 생성
                let buttonHorizontalStackView: UIStackView = {
                    let stackView = UIStackView()
                    stackView.axis = .horizontal
                    stackView.distribution = .fillProportionally
                    stackView.spacing = .spacing16
                    return stackView
                }()
                
                subButtonVerticalStackView.addArrangedSubview(buttonHorizontalStackView)
                subTermsButtons[index].setText(with: subTerm.title)
                buttonHorizontalStackView.addArrangedSubview(subTermsButtons[index])
                if subTerm.hasNextPage {
                    buttonHorizontalStackView.addArrangedSubview(subTermsOfArrowButtons[index])
                }
            }
            
        }
        
        func configureConstraints(for view: UIView) {
            backGroundView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            popUpView.snp.makeConstraints {
                $0.leading.bottom.trailing.equalToSuperview()
                $0.height.equalTo(Constants.Size.popupViewHeight)
            }
            
            popUpHeaderView.snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview()
                $0.height.equalTo(Constants.Size.popUpHeaderViewHeight)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.top.equalToSuperview().offset(.spacing40)
                $0.trailing.greaterThanOrEqualToSuperview().offset(.spacing20)
            }
            
            closeButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(.spacing12)
                $0.trailing.equalToSuperview().inset(.spacing12)
                $0.size.equalTo(Constants.Size.closeButtonSize)
            }
            
            allAgreeButton.snp.makeConstraints {
                $0.top.equalTo(popUpHeaderView.snp.bottom).offset(Constants.Size.allAggreeButtonTop)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constants.Size.termsButtonHeight)
            }
            
            dividerView.snp.makeConstraints {
                $0.top.equalTo(allAgreeButton.snp.bottom).offset(.spacing12)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constants.Size.dividerHeight)
            }
            
            subButtonVerticalStackView.snp.makeConstraints {
                $0.top.equalTo(dividerView.snp.bottom).offset(.spacing12)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
            }
            
            subButtonVerticalStackView.arrangedSubviews.forEach { buttonHorizontalStackView in
                buttonHorizontalStackView.snp.makeConstraints {
                    $0.height.equalTo(Constants.Size.termsButtonHeight)
                }
            }
            
            acceptButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constants.Size.acceptButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview().inset(.spacing16).priority(.low)
            }
            
        }
        
    }
}
