//
//  ProductSearchSortBottomSheetViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/30.
//

import UIKit

extension ProductSearchSortBottomSheetViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Text {
            static let titleLabelText: String = "정렬 선택"
        }
        
        enum Size {
            static let titleLabelHeight: CGFloat = 28
            static let closeButtonSize: CGFloat = 24
            static let buttonStackViewHeight: CGFloat = 174
        }
        
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.font = .title1
            label.textColor = .black
            label.text = Text.titleLabelText
            return label
        }()
        
        let closeButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.iconClose, for: .normal)
            return button
        }()
        
        let buttonStackView: UIStackView = {
            let stackView: UIStackView = .init(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = .spacing12
            return stackView
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(closeButton)
            contentView.addSubview(buttonStackView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(Size.titleLabelHeight)
                make.top.equalToSuperview().offset(.spacing40)
                make.leading.equalToSuperview().offset(.spacing20)
            }
            
            closeButton.snp.makeConstraints { make in
                make.size.equalTo(Size.closeButtonSize)
                make.leading.equalTo(titleLabel.snp.trailing).offset(.spacing12)
                make.top.trailing.equalToSuperview().inset(.spacing12)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.height.equalTo(Size.buttonStackViewHeight)
                make.top.equalTo(titleLabel.snp.bottom).offset(.spacing24)
                make.leading.trailing.equalToSuperview().inset(.spacing20)
                make.bottom.equalToSuperview().inset(.spacing40)
            }
        }
    }
}
