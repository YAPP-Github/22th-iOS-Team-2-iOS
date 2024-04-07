//
//  StarRatingReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import SnapKit

extension StarRatingReviewViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            static let navigationTitle: String = "상품 리뷰 작성하기"
            static let mainTitle: String = "이 상품에 만족하셨나요?"
            
            static let titleSpacing: CGFloat = 100
            static let productSpacing: CGFloat = 40
            static let starRatingSpacing: CGFloat = 60
            
            static let storeImageHeight: CGFloat = 30
            static let productImageSize: CGFloat = 160
        }
        
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
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.mainTitle
            return label
        }()
        
        private let productStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing12
            stackView.alignment = .center
            return stackView
        }()
        
        let storeImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let productImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            imageView.makeRounded(with: .spacing16)
            return imageView
        }()
        
        let productNameLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            return label
        }()
        
        let starRatingView = StarRatingView()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(titleLabel)
            view.addSubview(productStackView)
            view.addSubview(starRatingView)
            
            productStackView.addArrangedSubview(storeImageView)
            productStackView.addArrangedSubview(productImageView)
            productStackView.addArrangedSubview(productNameLabel)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom).offset(Constant.titleSpacing)
                $0.centerX.equalToSuperview()
            }
            
            productStackView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.productSpacing)
                $0.centerX.equalToSuperview()
            }
            
            storeImageView.snp.makeConstraints {
                $0.height.equalTo(Constant.storeImageHeight)
            }
            
            productImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.productImageSize)
            }
            
            starRatingView.snp.makeConstraints {
                $0.top.equalTo(productStackView.snp.bottom).offset(Constant.starRatingSpacing)
                $0.centerX.equalToSuperview()
            }
        }
    }
}
