//
//  DetailReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import SnapKit

extension DetailReviewViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            static let navigationTitle: String = "상품 리뷰 작성하기"
            
            static let detailReviewTitle: String = "좀 더 자세하게 알려주세요!"
            static let detailReviewPlaceholder: String = "상품에 대한 솔직한 의견을 알려주세요."
            
            static let imageUploadTitle: String = "사진 업로드"
            
            static let applyReviewTitle: String = "작성 완료"
            static let optionalText: String = " (선택)"
            
            static let imageUploadIcon: UIImage? = .init(systemName: "plus")
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
        
        let totalScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.keyboardDismissMode = .onDrag
            return scrollView
        }()
        
        private let contentStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        private let productTotalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = .spacing16
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: .spacing24,
                left: .spacing16,
                bottom: .spacing24,
                right: 0
            )
            return stackView
        }()
        
        let productImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            imageView.makeRounded(with: .spacing16)
            return imageView
        }()
        
        private let productInformationStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            stackView.alignment = .leading
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        let storeImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let productNameLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            label.numberOfLines = 1
            return label
        }()
        
        let starRatedView = StarRatedView(score: 0)
        
        private let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray100
            return view
        }()
        
        private let reviewButtonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing40
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: .spacing24,
                left: .spacing16,
                bottom: 0,
                right: .spacing16
            )
            return stackView
        }()
        
        let tasteReview: SingleLineReview = .init(evaluationKind: .taste)
        let qualityReview: SingleLineReview = .init(evaluationKind: .quality)
        let priceReview: SingleLineReview = .init(evaluationKind: .valueForMoney)
        
        private let detailReviewStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing20
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 60,
                left: .spacing16,
                bottom: .spacing40,
                right: .spacing16
            )
            return stackView
        }()
        
        let detailReviewLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.detailReviewTitle
            label.addAttributedString(
                newText: Constant.optionalText,
                font: .title1,
                color: .gray400
            )
            return label
        }()
        
        let detailReviewTextView: UITextView = {
            let textView = UITextView()
            textView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            textView.makeRounded(with: .spacing16)
            textView.textContainerInset = .init(
                top: .spacing12,
                left: .spacing12,
                bottom: .spacing12,
                right: .spacing12
            )
            textView.backgroundColor = .gray100
            textView.font = .body2r
            textView.textColor = .gray400
            return textView
        }()
        
        private let imageUploadStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .leading
            stackView.spacing = .spacing20
            stackView.axis = .vertical
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 0,
                left: .spacing16,
                bottom: 152,
                right: .spacing16
            )
            return stackView
        }()
        
        let imageUploadLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.imageUploadTitle
            label.addAttributedString(
                newText: Constant.optionalText,
                font: .title1,
                color: .gray400
            )
            return label
        }()
        
        let imageUploadButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.makeRounded(with: .spacing16)
            button.backgroundColor = .gray100
            button.setImage(Constant.imageUploadIcon, for: .normal)
            button.tintColor = .gray400
            return button
        }()
        
        let deleteImageButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconDeleteMedium, for: .normal)
            button.isHidden = true
            return button
        }()
        
        private let applyButtonBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let applyReviewButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Constant.applyReviewTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(totalScrollView)
            
            totalScrollView.addSubview(contentStackView)
            totalScrollView.addSubview(applyButtonBackgroundView)
            
            applyButtonBackgroundView.addSubview(applyReviewButton)
            
            contentStackView.addArrangedSubview(productTotalStackView)
            contentStackView.addArrangedSubview(separatorView)
            contentStackView.addArrangedSubview(reviewButtonStackView)
            contentStackView.addArrangedSubview(detailReviewStackView)
            contentStackView.addArrangedSubview(imageUploadStackView)
            
            productTotalStackView.addArrangedSubview(productImageView)
            productTotalStackView.addArrangedSubview(productInformationStackView)
            
            productInformationStackView.addArrangedSubview(storeImageView)
            productInformationStackView.addArrangedSubview(productNameLabel)
            productInformationStackView.addArrangedSubview(starRatedView)
            
            reviewButtonStackView.addArrangedSubview(tasteReview)
            reviewButtonStackView.addArrangedSubview(qualityReview)
            reviewButtonStackView.addArrangedSubview(priceReview)
            
            detailReviewStackView.addArrangedSubview(detailReviewLabel)
            detailReviewStackView.addArrangedSubview(detailReviewTextView)
            
            imageUploadStackView.addArrangedSubview(imageUploadLabel)
            imageUploadStackView.addArrangedSubview(imageUploadButton)
            
            imageUploadButton.addSubview(deleteImageButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            totalScrollView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
                $0.top.equalTo(backNavigationView.snp.bottom)
            }
            
            contentStackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.greaterThanOrEqualToSuperview()
            }
            
            applyButtonBackgroundView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).priority(.high)
                $0.bottom.lessThanOrEqualTo(view).inset(.spacing20)
                $0.height.equalTo(52)
            }
            
            applyReviewButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.height.equalToSuperview()
            }
            
            productTotalStackView.snp.makeConstraints {
                $0.leading.top.trailing.equalToSuperview()
            }
            
            productImageView.snp.makeConstraints {
                $0.width.height.equalTo(100)
            }
            
            storeImageView.snp.makeConstraints {
                $0.height.equalTo(20)
            }
            
            separatorView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(productTotalStackView.snp.bottom)
                $0.height.equalTo(12)
            }
            
            reviewButtonStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(separatorView.snp.bottom)
            }
            
            detailReviewStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
            }
            
            detailReviewTextView.snp.makeConstraints {
                $0.height.equalTo(200)
            }
            
            imageUploadStackView.snp.makeConstraints {
                $0.leading.equalToSuperview()
            }
            
            imageUploadButton.snp.makeConstraints {
                $0.width.height.equalTo(120)
            }
            
            deleteImageButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(6)
                $0.trailing.equalToSuperview().inset(6)
            }
        }
    }
}
