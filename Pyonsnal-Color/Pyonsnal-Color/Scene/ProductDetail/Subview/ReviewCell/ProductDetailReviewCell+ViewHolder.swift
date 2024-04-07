//
//  ProductDetailReviewCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

extension ProductDetailReviewCell {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Size {
            static let writeButtonRadius: CGFloat = 8
        }
        
        // MARK: - UI Component
        let contentView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            return view
        }()
        
        let contentStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 16
            return stackView
        }()
        
        let reviewMetaView: ReviewMetaView = {
            let reviewMetaView = ReviewMetaView()
            return reviewMetaView
        }()
        
        let reviewImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.makeRounded(with: 16)
            return imageView
        }()
        
        let reviewTagListView: ReviewTagListView = {
            let view = ReviewTagListView()
            return view
        }()
        
        let reviewLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            label.font = .body2r
            label.textColor = .gray700
            label.text = ""
            return label
        }()
        
        let buttonBackgroundView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let goodButton: ReviewFeedbackButton = {
            let button = ReviewFeedbackButton()
            button.payload = .init(feedbackKind: .good, isSelected: false, count: 0)
            return button
        }()
        
        let badButton: ReviewFeedbackButton = {
            let button = ReviewFeedbackButton()
            button.payload = .init(feedbackKind: .bad, isSelected: false, count: 0)
            return button
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(separatorView)
            contentView.addSubview(contentStackView)
            contentView.addSubview(reviewLabel)
            contentView.addSubview(buttonBackgroundView)
            
            contentStackView.addArrangedSubview(reviewMetaView)
            contentStackView.addArrangedSubview(reviewImageView)
            contentStackView.addArrangedSubview(reviewTagListView)
            
            buttonBackgroundView.addSubview(goodButton)
            buttonBackgroundView.addSubview(badButton)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            separatorView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(.spacing20)
            }
            
            contentStackView.snp.makeConstraints { make in
                make.top.equalTo(separatorView.snp.bottom).offset(.spacing20)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
            }
            
            reviewLabel.snp.makeConstraints { make in
                make.top.equalTo(contentStackView.snp.bottom).offset(.spacing12)
                make.leading.trailing.equalToSuperview().inset(.spacing20)
            }
            
            buttonBackgroundView.snp.makeConstraints { make in
                make.top.equalTo(reviewLabel.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview().inset(.spacing20)
            }
            
            reviewImageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(reviewImageView.snp.width)
            }
            
            goodButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.bottom.equalToSuperview()
            }
            
            badButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(goodButton.snp.trailing).offset(.spacing8)
                make.trailing.equalToSuperview()
            }
        }
    }
}
